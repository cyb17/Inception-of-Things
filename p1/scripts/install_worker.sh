#!/bin/bash

# Stop script if a command fails
set -e

echo "K3S AGENT INSTALLING..."

TOKEN=$(cat /vagrant/shared/node-token)
SERVER_IP=$(cat /vagrant/shared/server-ip)

curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$TOKEN" sh -

echo '=> SHOW STATUS : '
echo "$(sudo systemctl status k3s-agent)"
