
#!/bin/bash
set -e

echo "Installing K3s agent..."

# Wait until the node-token exists
while [ ! -f /vagrant/shared/node-token ]; do
  echo "Waiting for server token..."
  sleep 2
done

TOKEN=$(cat /vagrant/shared/node-token)

$(rm -rf /vagrant/shared)

# Forcing K3s to bind on the private network
curl -sfL https://get.k3s.io | K3S_URL="https://192.168.56.110:6443" K3S_TOKEN="$TOKEN" sh -s - --node-ip=192.168.56.111

sudo systemctl status k3s-agent --no-pager -l

