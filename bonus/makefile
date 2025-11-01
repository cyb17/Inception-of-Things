.PHONY: build serve clean re

all: build

build:
	@bash ./scripts/infra_setup.sh

gitlab-secret:
	@kubectl get secret my-gitlab-secrets -n gitlab -o jsonpath="{.data.root-password}" | base64 --decode

argo-secret: 
	@argocd admin initial-password -n argocd

clean:
	@k3d cluster delete iof-cluster

re: clean all
