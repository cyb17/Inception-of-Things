.PHONY: build serve clean re

all: build serve

build:
	@bash ./infra_setup.sh

serve:
	@kubectl port-forward svc/argocd-server -n argocd 30080:443 --address=0.0.0.0 &

clean:
	@k3d cluster delete iof-cluster

re: clean all
