#!/bin/bash
set -e

echo "Installing K3s server..."

# Forcing K3s to bind on the private network
curl -sfL https://get.k3s.io | sh -s - --node-ip=192.168.56.110 --bind-address=192.168.56.110

# Make sure node-token is accessible by the agent
mkdir -p /vagrant/shared
cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/

sudo systemctl status k3s --no-pager -l

