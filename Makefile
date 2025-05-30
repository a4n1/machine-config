OS := $(shell uname)

HOST ?= host

ifeq ($(OS), Darwin)
DEPLOY_COMMAND = nix build .\#darwinConfigurations.$(HOST).system \
	&& sudo ./result/sw/bin/darwin-rebuild switch --flake .\#$(HOST)
else ifeq ($(OS), Linux)
DEPLOY_COMMAND = sudo nixos-rebuild switch --flake .\#$(HOST)-vm
endif

deploy:
	$(DEPLOY_COMMAND)
