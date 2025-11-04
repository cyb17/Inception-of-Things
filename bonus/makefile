.PHONY: build serve clean re

all: build

build:
	@bash ./scripts/infra_setup.sh

deploy:
	@kubectl apply -f ./confs/wil42-github.yaml
	@kubectl apply -f ./confs/wil42-gitlab.yaml

gitlab-secret:
	@kubectl get secret  gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
argo-secret: 
	@argocd admin initial-password -n argocd

clean:
	@k3d cluster delete iof-cluster

re: clean all
