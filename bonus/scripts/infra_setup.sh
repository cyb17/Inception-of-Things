#!/bin/bash
set -e

# -----------------------------
# Variables
# -----------------------------
CLUSTER_NAME="iof-cluster"
ARGOCD_NAMESPACE="argocd"
DEV_NAMESPACE="dev"
GITLAB_NAMESPACE="gitlab"

GIT_REPO_URL="https://github.com/cyb17/yachen.git"
GIT_REPO_PATH="dev"
GIT_REPO_BRANCH="main"
APP_NAME="my-app"

# -----------------------------
#  Create K3d cluster
# -----------------------------
echo "🚀 Creating K3d cluster..."
k3d cluster create $CLUSTER_NAME --port "30081:30081"
echo '---------------------------------'

# -----------------------------
#  Create namespaces
# -----------------------------
echo "🚀 Creating namespaces..."
kubectl create namespace $ARGOCD_NAMESPACE || echo "Namespace $ARGOCD_NAMESPACE exists"
kubectl create namespace $DEV_NAMESPACE || echo "Namespace $DEV_NAMESPACE exists"
kubectl create namespace $GITLAB_NAMESPACE || echo "Namespace $GITLAB_NAMESPACE exists"
echo '---------------------------------'

# -----------------------------
#  Install ArgoCD
# -----------------------------
echo "🚀 Installing ArgoCD..."
kubectl apply -n $ARGOCD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo '---------------------------------'

# --------------------------------------
#  Display ArgoCD initial admin password
# --------------------------------------
kubectl -n argocd wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=120s
echo "🚀 To access ArgoCD..."
echo 'username : admin'
echo "password : $(argocd admin initial-password -n argocd)"
echo '---------------------------------'

# -----------------------------
#  Create ArgoCD Application
# -----------------------------
echo "🚀 Creating ArgoCD Application to track GitHub repo..."

cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: $APP_NAME
  namespace: $ARGOCD_NAMESPACE
spec:
  project: default
  source:
    repoURL: $GIT_REPO_URL
    targetRevision: $GIT_REPO_BRANCH
    path: $GIT_REPO_PATH
  destination:
    server: https://kubernetes.default.svc
    namespace: $DEV_NAMESPACE
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF

echo '---------------------------------'
echo "🎉 Setup complete! -> Run make serve -> Argocd can be accessed now from host at https://localhost:8080 OR vm at https://localhost:30080"
echo '---------------------------------'
