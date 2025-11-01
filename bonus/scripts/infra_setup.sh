#!/bin/bash
set -e

# -----------------------------
# Variables
# -----------------------------
CLUSTER_NAME="iof-cluster"

DEV_NAMESPACE="dev"
GITLAB_NAMESPACE="gitlab"
ARGOCD_NAMESPACE="argocd"

GITLAB_VALUES_FILE="/home/yachen/Inception-of-Things/bonus/confs/gitlab/my-gitlab-values.yaml"
ARGOCD_VALUES_FILE="/home/yachen/Inception-of-Things/bonus/confs/argocd/my-argo-values.yaml"
ARGOCD_INGRESS_FILE="/home/yachen/Inception-of-Things/bonus/confs/argocd/my-argo-ingress.yaml"

ARGOCD_ACCESS_URL="http://argocd.local/"
GITLAB_ACCESS_URL="http://gitlab.local/"

# -----------------------------
#  Create K3d cluster
# -----------------------------
echo "🚀 Creating K3d cluster..."
k3d cluster create $CLUSTER_NAME
echo '---------------------------------'

# -----------------------------
#  Create namespaces
# -----------------------------
echo "🚀 Creating namespaces..."
kubectl create namespace $ARGOCD_NAMESPACE
kubectl create namespace $DEV_NAMESPACE
kubectl create namespace $GITLAB_NAMESPACE
echo '---------------------------------'

# -----------------------------
#  Install ArgoCD
# -----------------------------
echo "🚀 Installing ArgoCD..."
helm install argocd argo/argo-cd -n argocd -f $ARGOCD_VALUES_FILE
echo '---------------------------------'

# -------------------------------
#  Add Traefik Ingress for ArgoCD
# -------------------------------
echo "🚀 Adding Traefik Ingress for ArgoCD..."
kubectl apply -f $ARGOCD_INGRESS_FILE -n argocd
echo '---------------------------------'

# -----------------------------
#  Install gitlab
# -----------------------------
echo "🚀 Installing gitlab..."
helm install gitlab gitlab/gitlab -n gitlab -f $GITLAB_VALUES_FILE
echo '---------------------------------'

# --------------------------------------
#  Display ArgoCD/gitlab initial admin password
# --------------------------------------
echo "🚀 To access ArgoCD..."
kubectl -n argocd wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=120s
echo 'username : admin'
echo "password : $(argocd admin initial-password -n argocd)"
echo '---------------------------------'

echo "🚀 To access gitlab..."
echo 'username : root'
echo "password : $(kubectl get secret my-gitlab-secrets -n gitlab -o jsonpath="{.data.root-password}" | base64 --decode
echo -n)"
echo '---------------------------------'

echo '---------------------------------'
echo "🎉 Setup complete!"
echo "-> Argocd can be accessed now at $ARGOCD_ACCESS_URL"
echo "-> Gitlab can be accessed now at $GITLAB_ACCESS_URL"
echo '---------------------------------'
