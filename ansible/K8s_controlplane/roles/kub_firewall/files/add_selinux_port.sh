#!/bin/bash
set -e

# Ensure semanage command is available
if ! command -v semanage &>/dev/null; then
  echo "semanage not found, installing policycoreutils-python-utils..."
  sudo dnf install -y policycoreutils-python-utils
fi

# Define the ports and ranges
PORTS=(6443 2379 2380 9090 3000 10250 10251 10252)
#PORT_RANGE_START=30000
#PORT_RANGE_END=32767

echo "Adding SELinux port contexts for Kubernetes and monitoring TCP ports..."

# Function to add SELinux port if not exists
add_port() {
  local port=$1
  # Check if port is already defined in SELinux
  if semanage port -l | grep -w "^http_port_t" | grep -w "tcp" | grep -w "$port" &>/dev/null; then
    echo "Port $port/tcp already defined in SELinux, skipping."
  else
    echo "Adding port $port/tcp to SELinux http_port_t context..."
    sudo semanage port -a -t http_port_t -p tcp "$port"
  fi
}

# Add single ports
for p in "${PORTS[@]}"; do
  add_port "$p"
done

# Add port range
#for ((port=PORT_RANGE_START; port<=PORT_RANGE_END; port++)); do
#  add_port "$port"
#done

echo "SELinux port context configuration completed."
