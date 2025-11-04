.PHONY: build serve clean re

all: build

build:
	@bash ./scripts/infra_setup.sh

clean:
	@k3d cluster delete iof-cluster

re: clean all
