#!/bin/bash
set -e

# ------------------------------------------------------------------------------
# 1. Créer un cluster k3d avec un port exposé (30080 -> 80 dans le cluster)
# ------------------------------------------------------------------------------
CLUSTER_NAME="mycluster"

echo "🔹 Création du cluster k3d : $CLUSTER_NAME..."
k3d cluster create $CLUSTER_NAME \
  --api-port 6550 \
  -p "30080:80@loadbalancer" \
  -p "30443:443@loadbalancer"

echo "✅ Cluster $CLUSTER_NAME créé avec succès"

# ------------------------------------------------------------------------------
# 2. Créer le namespace argocd
# ------------------------------------------------------------------------------
echo "🔹 Création du namespace argocd..."
kubectl create namespace argocd || echo "Namespace argocd déjà existant"

# ------------------------------------------------------------------------------
# 3. Installer ArgoCD via le manifest officiel
# ------------------------------------------------------------------------------
echo "🔹 Installation d'ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "✅ ArgoCD installé dans le namespace argocd"

# ------------------------------------------------------------------------------
# 4. Exposer l'UI ArgoCD
# ------------------------------------------------------------------------------
echo "🔹 Exposition de l'UI ArgoCD..."

# On transforme le service ArgoCD Server en NodePort pour qu’il passe par le loadbalancer k3d
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

echo "✅ ArgoCD UI exposée. Accède-y depuis ton host :"
echo "   👉 http://localhost:30080"

# ------------------------------------------------------------------------------
# 5. Récupérer le mot de passe admin initial
# ------------------------------------------------------------------------------
echo "🔹 Récupération du mot de passe admin..."
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
echo -e "\n✅ Utilise le login: admin et le mot de passe ci-dessus pour te connecter."

