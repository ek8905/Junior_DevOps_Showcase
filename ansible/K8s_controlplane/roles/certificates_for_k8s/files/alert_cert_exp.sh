#!/bin/bash

set -euo pipefail

CERT_DIR="/var/lib/kubernetes/pki"
ETCD_CERT_DIR="/etc/etcd"

THRESHOLD_DAYS=30
DATE_NOW=$(date +%s)

echo "==== Certificate expiry check started at $(date) ===="

check_cert_expiry() {
    local cert_file=$1
    if [[ ! -f "$cert_file" ]]; then
        echo "WARNING: Certificate file $cert_file does not exist!" 
        return 1
    fi

    # Get expiry date in seconds since epoch
    local expiry_date
    expiry_date=$(openssl x509 -enddate -noout -in "$cert_file" | cut -d= -f2)
    local expiry_epoch
    expiry_epoch=$(date -d "$expiry_date" +%s)

    # Calculate days left
    local days_left=$(( (expiry_epoch - DATE_NOW) / 86400 ))

    if (( days_left < THRESHOLD_DAYS )); then
        echo "ALERT: Certificate $cert_file expires in $days_left day(s) on $expiry_date" 
        return 1
    else
        echo "OK: Certificate $cert_file expires in $days_left day(s) on $expiry_date" 
        return 0
    fi
}

# List of certs to check
certs=(
    "${CERT_DIR}/ca.crt"
    "${CERT_DIR}/kube-apiserver.crt"
    "${CERT_DIR}/kube-controller-manager.crt"
    "${CERT_DIR}/kube-scheduler.crt"
    "${CERT_DIR}/admin.crt"
    "${CERT_DIR}/kube-proxy.crt"
    "${ETCD_CERT_DIR}/etcd-server.crt"
    "${ETCD_CERT_DIR}/etcd-peer.crt"
)

any_expiring=0

for cert in "${certs[@]}"; do
    if ! check_cert_expiry "$cert"; then
        any_expiring=1
    fi
done

echo "==== Certificate expiry check finished at $(date) ====" 
echo 

if (( any_expiring == 1 )); then
    exit 1
else
    exit 0
fi

# Uncomment below to send email alert (requires mailx or other mail client)
# echo "Certificate $cert_file expires in $days_left day(s) on $expiry_date" | mail -s "K8s Certificate Expiry Alert" you@example.com
