#!/bin/bash

set -euo pipefail

CERT_DIR="/var/lib/kubernetes/pki"
CA_KEY="${CERT_DIR}/ca.key"
CA_CERT="${CERT_DIR}/ca.crt"
WORKER_HOSTNAME="k8sworker"
WORKER_IP="192.168.0.103"
TMP_DIR="/tmp"

mkdir -p "$CERT_DIR"

create_cnf_files() {
  cat > "${TMP_DIR}/kubelet_worker_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name
req_extensions = req_ext

[ req_distinguished_name ]
CN = system:node:${WORKER_HOSTNAME}.project.local
O = system:nodes

[ req_ext ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${WORKER_HOSTNAME}
DNS.2 = k8sworker.project.local
IP.1 = ${WORKER_IP}
IP.2 = 127.0.0.1
EOF

  cat > "${TMP_DIR}/kube-proxy_worker_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
CN = system:kube-proxy
O = system:node-proxier
EOF
}

generate_cert_with_ext() {
  local name="$1"
  local cnf="$2"
  local key="${CERT_DIR}/${name}.key"
  local csr="${TMP_DIR}/${name}.csr"
  local crt="${CERT_DIR}/${name}.crt"

  echo "[+] Generating private key for ${name}..."
  openssl genrsa -out "$key" 4096

  echo "[+] Generating CSR for ${name}..."
  openssl req -new -key "$key" -out "$csr" -config "$cnf"

  echo "[+] Signing certificate for ${name} (with extensions)..."
  openssl x509 -req -in "$csr" \
    -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
    -out "$crt" -days 365 -sha256 \
    -extensions req_ext -extfile "$cnf"

  echo "[✓] Certificate for ${name} created with extensions."
}

generate_cert() {
  local name="$1"
  local cnf="$2"
  local key="${CERT_DIR}/${name}.key"
  local csr="${TMP_DIR}/${name}.csr"
  local crt="${CERT_DIR}/${name}.crt"

  echo "[+] Generating private key for ${name}..."
  openssl genrsa -out "$key" 4096

  echo "[+] Generating CSR for ${name}..."
  openssl req -new -key "$key" -out "$csr" -config "$cnf"

  echo "[+] Signing certificate for ${name}..."
  openssl x509 -req -in "$csr" \
    -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
    -out "$crt" -days 365 -sha256

  echo "[✓] Certificate for ${name} created."
}

restart_service() {
  local service="$1"
  echo "[*] Restarting $service..."
  systemctl daemon-reexec
  systemctl restart "$service"
  echo "[✓] $service restarted."
}

show_menu() {
  echo "Select certificate(s) to regenerate:"
  echo "1) kubelet-worker"
  echo "2) kube-proxy-worker"
  echo "3) Both"
  echo "0) Exit"
  echo -n "Choice: "
}

main() {
  create_cnf_files
  declare -a choices=()

  show_menu
  read -r choice

  case "$choice" in
    1) choices=("kubelet-worker") ;;
    2) choices=("kube-proxy-worker") ;;
    3) choices=("kubelet-worker" "kube-proxy-worker") ;;
    0) echo "Exiting." && exit 0 ;;
    *) echo "Invalid choice." && exit 1 ;;
  esac

  for cert in "${choices[@]}"; do
    case "$cert" in
      kubelet-worker)
        generate_cert_with_ext "$WORKER_HOSTNAME" "${TMP_DIR}/kubelet_worker_openssl.cnf"
        restart_service "kubelet"
        ;;
      kube-proxy-worker)
        generate_cert "kube-proxy-worker" "${TMP_DIR}/kube-proxy_worker_openssl.cnf"
        restart_service "kube-proxy"
        ;;
    esac
  done

  echo "[✓] Selected certificates regenerated and services restarted."
}

main
