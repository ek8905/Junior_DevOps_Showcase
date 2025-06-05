#!/bin/bash

set -euo pipefail

CERT_DIR="/var/lib/kubernetes/pki"
CA_CERT="${CERT_DIR}/ca.crt"
CA_KEY="${CERT_DIR}/ca.key"
CNF="/tmp/admin_openssl.cnf"
KEY="${CERT_DIR}/admin.key"
CSR="/tmp/admin.csr"
CRT="${CERT_DIR}/admin.crt"

# Ensure directory exists
mkdir -p "$CERT_DIR"

cat > "$CNF" <<EOF
[ req ]
default_bits       = 4096
prompt             = no
default_md         = sha256
distinguished_name = dn

[ dn ]
CN = admin
O  = system:masters
EOF


# Check if config file exists
if [[ ! -f "$CNF" ]]; then
  echo "[✗] CNF file $CNF not found. Aborting."
  exit 1
fi

echo "[!] Forcing regeneration of admin certificate..."

# Generate private key
echo "[+] Generating admin private key..."
openssl genrsa -out "$KEY" 4096

# Generate CSR
echo "[+] Generating admin certificate signing request (CSR)..."
openssl req -new -key "$KEY" -out "$CSR" -config "$CNF"

# Sign certificate
echo "[+] Signing admin certificate with CA..."
openssl x509 -req -in "$CSR" \
  -CA "$CA_CERT" -CAkey "$CA_KEY" -CAcreateserial \
  -out "$CRT" -days 365 -sha256

echo "[✓] Admin certificate regenerated and valid for 1 year."
