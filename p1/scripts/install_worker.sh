#!/bin/bash

GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

echo -e "${YELLOW}k3s agent installing...${NC}"

TOKEN=$(cat /vagrant/shared/node-token)
SERVER_IP=$(cat /vagrant/shared/server-ip)

echo "${TOKEN}"
echo "${SERVER_IP}"

if curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$TOKEN" sh -; then
    echo -e "${GREEN}k3s agent installed with success!${NC}"
else
    echo -e "${RED}Failed to install k3s agent${NC}"
    exit 1
fi

