.PHONY: build serve clean re

all: build serve

build:
	@bash ./scripts/infra_setup.sh

serve: down
	@kubectl port-forward svc/argocd-server -n argocd 30080:443 --address=0.0.0.0 &

down:
	@pid=$$(lsof -ti:30080); \
	if [ -n "$$pid" ]; then \
		kill $$pid; \
	fi

clean: down
	@k3d cluster delete iof-cluster

re: clean all
