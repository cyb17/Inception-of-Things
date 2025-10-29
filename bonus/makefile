.PHONY: build serve clean re

all: build serve

build:
	@bash ./scripts/infra_setup.sh

serve-argocd:
	@kubectl port-forward svc/argocd-server -n argocd 8443:443 --address localhost,10.0.2.15
serve-gitlab:
	@kubectl port-forward svc/gitlab-webservice-default -n gitlab 8080:8080 --address localhost,10.0.2.15

down:
	@pid=$$(lsof -ti:8080); \
	if [ -n "$$pid" ]; then \
		read -p "Process $$pid is listening on port 8080. Kill it? [y/N] " ans; \
		if [ "$$ans" = "y" ] || [ "$$ans" = "Y" ]; then \
			kill $$pid && echo "Killed $$pid"; \
		else \
			echo "Canceled."; \
		fi; \
	else \
		echo "No process on port 8080."; \
	fi


clean:
	@k3d cluster delete iof-cluster

re: clean all
