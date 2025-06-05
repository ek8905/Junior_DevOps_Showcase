#!/bin/bash

cert_dir="/var/lib/kubernetes/pki"
ca_key="${cert_dir}/ca.key"
ca_cert="${cert_dir}/ca.crt"
openssl_cnf="/tmp/etcd-server-openssl.cnf"
etcd_key="/etc/etcd/etcd-server.key"
etcd_csr="/etc/etcd/etcd-server.csr"
etcd_crt="/etc/etcd/etcd-server.crt"

master_ip="192.168.0.102"

# Create the OpenSSL config file used for SAN IPs
cat > "$openssl_cnf" <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[ dn ]
CN = etcd-server 
O = Kubernetes


[req_distinguished_name]

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = $master_ip
IP.2 = 127.0.0.1
EOF

# Function to check cert expiry in days
cert_expires_in_days() {
  if [[ ! -f "$1" ]]; then
    echo -1
    return
  fi
  end_date=$(openssl x509 -enddate -noout -in "$1" | cut -d= -f2)
  end_date_seconds=$(date -d "$end_date" +%s)
  now_seconds=$(date +%s)
  diff_seconds=$((end_date_seconds - now_seconds))
  echo $((diff_seconds / 86400))
}

days_left=$(cert_expires_in_days "$etcd_crt")

echo "etcd-server.crt expires in $days_left days"

if [[ $days_left -lt 30 ]]; then
  echo "Regenerating etcd server cert/key..."

  mkdir -p /etc/etcd

  # Generate private key
  openssl genrsa -out "$etcd_key" 4096

  # Generate CSR with subject CN=etcd-server/O=Kubernetes
  openssl req -new -key "$etcd_key" -subj "/CN=etcd-server/O=Kubernetes" -out "$etcd_csr" -config "$openssl_cnf"

  # Sign cert with CA, valid for 1000 days
  openssl x509 -req -in "$etcd_csr" -CA "$ca_cert" -CAkey "$ca_key" -CAcreateserial \
    -out "$etcd_crt" -extensions v3_req -extfile "$openssl_cnf" -days 365

  # Clean up CSR and serial file
  rm -f "$etcd_csr" "${ca_cert%.crt}.srl"

  echo "etcd server certificate regenerated successfully."

else
  echo "Certificate still valid for more than 30 days. No action taken."
fi

# Optionally, clean up the OpenSSL config
rm -f "$openssl_cnf"
