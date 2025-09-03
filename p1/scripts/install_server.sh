#!/bin/bash

# Stop script if any command fails
set -e

echo 'K3S SERVER INSTALLING...'
curl -sfL https://get.k3s.io | sh -

echo '=> SHOW STATUS : '
echo "$(sudo systemctl status k3s)"

# Create shared folder and copy necessary data
mkdir -p /vagrant/shared

cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/
