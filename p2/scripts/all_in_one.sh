#!/bin/bash

K='sudo k3s kubectl'
K3S_SERVER_IP='192.168.56.110'

set -e

# Installer K3s
curl -sfL https://get.k3s.io | sh -s - --node-ip=${K3S_SERVER_IP}

# Attendre que K3s soit prêt
until sudo k3s kubectl get nodes &>/dev/null; do
  echo "⏳ Waiting for K3s to be ready..."
  sleep 5
done

# Appliquer les applications
echo "================================ Applying yaml configuration files..."
${K} apply -f /vagrant/confs/app1.yaml
${K} apply -f /vagrant/confs/app2.yaml
${K} apply -f /vagrant/confs/app3.yaml
${K} apply -f /vagrant/confs/ingress.yaml

# Attendre que les déploiements soient dispo
echo "================================ Waiting for deployments..."
${K} wait --for=condition=available --timeout=120s deployment --all

# Vérifier les ressources
${K} get all

