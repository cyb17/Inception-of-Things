#!/bin/bash

GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Stop script if any command fails
set -e

echo -e "${YELLOW}k3s server installing...${NC}"
curl -sfL https://get.k3s.io | sh -

if which k3s > /dev/null 2>&1; then
    echo -e "${GREEN}k3s installed with success !${NC}"
else
    echo -e "${RED}failed to install k3s${NC}"
    exit 1
fi

# Create shared folder and copy necessary data
echo -e "${YELLOW}Creating shared folder and data for k3s Agent installation...${NC}"
mkdir -p /vagrant/shared

cp /var/lib/rancher/k3s/server/node-token /vagrant/shared/
hostname -i > /vagrant/shared/server-ip

