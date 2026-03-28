OS := $(shell uname)
HOST ?= host

ifeq ($(OS), Darwin)
DEPLOY_COMMAND = nix build .\#darwinConfigurations.$(HOST).system \
	&& sudo ./result/sw/bin/darwin-rebuild switch --flake .\#$(HOST)
else ifeq ($(OS), Linux)
ifeq ($(HOST), thirver)
DEPLOY_COMMAND = \
	podman pull docker.io/a4n1/notes:latest && \
	podman pull docker.io/a4n1/gobble:latest && \
	sudo nixos-rebuild switch --flake .\#$(HOST)
else
DEPLOY_COMMAND = sudo nixos-rebuild switch --flake .\#$(HOST)-vm
endif
endif

deploy:
	$(DEPLOY_COMMAND)
