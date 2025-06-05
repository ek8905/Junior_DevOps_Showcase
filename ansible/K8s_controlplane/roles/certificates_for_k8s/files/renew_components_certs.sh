#!/bin/bash

set -euo pipefail

CERT_DIR="/var/lib/kubernetes/pki"
CA_KEY="${CERT_DIR}/ca.key"
CA_CERT="${CERT_DIR}/ca.crt"
MASTER_HOSTNAME="k8smaster"
MASTER_IP="192.168.0.102"
TMP_DIR="/tmp"

mkdir -p "$CERT_DIR"

create_cnf_files() {
  cat > "${TMP_DIR}/kube-controller-manager_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
CN = system:kube-controller-manager
O = system:kube-controller-manager
EOF

  cat > "${TMP_DIR}/kube-scheduler_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
CN = system:kube-scheduler
O = system:kube-scheduler
EOF

  cat > "${TMP_DIR}/kube-proxy_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name

[ req_distinguished_name ]
CN = system:kube-proxy
O = system:node-proxier
EOF

  cat > "${TMP_DIR}/${MASTER_HOSTNAME}_openssl.cnf" <<EOF
[ req ]
prompt = no
distinguished_name = req_distinguished_name
req_extensions = v3_req

[ req_distinguished_name ]
CN = system:node:${MASTER_HOSTNAME}.project.local
O = system:nodes

[ v3_req ]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth, clientAuth
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = ${MASTER_HOSTNAME}
DNS.2 = k8smaster.project.local
IP.1 = ${MASTER_IP}
IP.2 = 127.0.0.1
EOF
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
    -extensions v3_req -extfile "$cnf"

  echo "[✓] Certificate for ${name} with extensions created."
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
  echo "1) kube-controller-manager"
  echo "2) kube-scheduler"
  echo "3) kube-proxy"
  echo "4) kubelet (master node)"
  echo "5) All of the above"
  echo "0) Exit"
  echo -n "Choice: "
}

main() {
  create_cnf_files
  declare -a choices=()

  show_menu
  read -r choice

  case "$choice" in
    1) choices=("kube-controller-manager") ;;
    2) choices=("kube-scheduler") ;;
    3) choices=("kube-proxy") ;;
    4) choices=("${MASTER_HOSTNAME}") ;;
    5) choices=("kube-controller-manager" "kube-scheduler" "kube-proxy" "${MASTER_HOSTNAME}") ;;
    0) echo "Exiting." && exit 0 ;;
    *) echo "Invalid choice." && exit 1 ;;
  esac

  for cert in "${choices[@]}"; do
    cnf_path="${TMP_DIR}/${cert}_openssl.cnf"

    if [[ ! -f "$cnf_path" ]]; then
      echo "CNF file ${cnf_path} not found. Aborting."
      exit 1
    fi

    if [[ "$cert" == "${MASTER_HOSTNAME}" ]]; then
      generate_cert_with_ext "$cert" "$cnf_path"
      restart_service "kubelet"
    else
      generate_cert "$cert" "$cnf_path"
      case "$cert" in
        kube-controller-manager) restart_service "kube-controller-manager" ;;
        kube-scheduler) restart_service "kube-scheduler" ;;
        kube-proxy) restart_service "kube-proxy" ;;
      esac
    fi
  done

  echo "[✓] All selected certificates regenerated and services restarted."
}

main
