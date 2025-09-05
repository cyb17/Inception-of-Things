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
echo "================================ Applying apps.yaml"
${K} apply -f /vagrant/apps.yaml

# Attendre que les déploiements soient dispo
echo "================================ Waiting for deployments..."
${K} wait --for=condition=available --timeout=120s deployment --all

# Vérifier les ressources
${K} get all

# Petite pause pour laisser Traefik prendre en compte l’ingress
sleep 5

# Tester les applications via Ingress
echo "================================ get apps's response"
curl -H "Host: app1.com" http://${K3S_SERVER_IP}
echo "================================"
curl -H "Host: app2.com" http://${K3S_SERVER_IP}
echo "================================"
curl -H "Host: unknown.com" http://${K3S_SERVER_IP}

