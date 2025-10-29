#!/bin/bash
set -e

# -----------------------------
# Variables
# -----------------------------
CLUSTER_NAME="iof-cluster"
ARGOCD_NAMESPACE="argocd"
DEV_NAMESPACE="dev"
GITLAB_NAMESPACE="gitlab"

ARGO_VALUES_FILE="/home/yachen/iof/bonus/confs/my-argo-values.yaml"
GITLAB_VALUES_FILE="/home/yachen/iof/bonus/confs/my-gitlab-values.yaml"


GIT_REPO_URL="https://github.com/cyb17/yachen.git"
GIT_REPO_PATH="dev"
GIT_REPO_BRANCH="main"
APP_NAME="wil42"

ARGOCD_ACCESS_URL="http://localhost:8443"
GITLAB_ACCESS_URL="http://locahost:8080"

# -----------------------------
#  Create K3d cluster
# -----------------------------
echo "🚀 Creating K3d cluster..."
k3d cluster create $CLUSTER_NAME -p "8443:30443@server:0" -p "8080:30080@server:0"
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
helm install argocd argo/argo-cd -n argocd -f $ARGO_VALUES_FILE
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
kubectl -n argocd wait --for=condition=Ready pod -l app.kubernetes.io/name=argocd-server --timeout=120s
echo "🚀 To access ArgoCD..."
echo 'username : admin'
echo "password : $(argocd admin initial-password -n argocd)"
echo '---------------------------------'

echo "🚀 To access gitlab..."
echo 'username : root'
echo "password : $(kubectl get secret my-gitlab-secrets -n gitlab -o jsonpath="{.data.root-password}" | base64 --decode
echo -n)"
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
echo "🎉 Setup complete!"
echo "-> Argocd can be accessed now from host or VM at $ARGOCD_ACCESS_URL"
echo '---------------------------------'
