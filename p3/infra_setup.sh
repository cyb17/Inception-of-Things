#!/bin/bash
set -e

# -----------------------------
# Variables
# -----------------------------
CLUSTER_NAME="iof-cluster"
ARGOCD_NAMESPACE="argocd"
DEV_NAMESPACE="dev"

GIT_REPO_URL="https://github.com/cyb17/yachen.git"
GIT_REPO_PATH="yachen"
GIT_REPO_BRANCH="main"
APP_NAME="my-app"

# -----------------------------
#  Create K3d cluster
# -----------------------------
echo "🚀 Creating K3d cluster..."
k3d cluster create $CLUSTER_NAME

# -----------------------------
#  Create namespaces
# -----------------------------
echo "🚀 Creating namespaces..."
kubectl create namespace $ARGOCD_NAMESPACE || echo "Namespace $ARGOCD_NAMESPACE exists"
kubectl create namespace $DEV_NAMESPACE || echo "Namespace $DEV_NAMESPACE exists"

# -----------------------------
#  Install ArgoCD
# -----------------------------
echo "🚀 Installing ArgoCD..."
kubectl apply -n $ARGOCD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# -----------------------------------------------------
#  expose ArgoCD with a forward-port 8080 in background
# -----------------------------------------------------
#echo "🚀 expose ArgoCD to be accessible from host..."
#kubectl port-forward svc/argocd-server -n argocd 8080:80 --address=0.0.0.0 &

# --------------------------------------
#  Display ArgoCD initial admin password
# --------------------------------------
kubectl -n argocd wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=120s
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo

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

echo "🎉 Setup complete! ArgoCD can be accessed from host wor vm at http://localhost:8080"
echo "The app '$APP_NAME' will be automatically deployed to namespace '$DEV_NAMESPACE'."

