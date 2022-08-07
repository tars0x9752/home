.PHONY: hello
hello:
	nix run '.#figlet' -- -f isometric1 -c "Hello World"

.PHONY: ls-pkg
ls-pkg:
	home-manager packages

.PHONY: ls-gen
ls-gen:
	home-manager generations

.PHONY: fmt
fmt:
	nix fmt

.PHONY: install
install: export HOME_MANAGER_BACKUP_EXT = old
install:
	nix run '.#activate/tars'

.PHONY: switch
switch:
	home-manager switch --flake '.#tars' -b bck --impure

.PHONY: update
update:
	home-manager switch --flake '.#tars' -b bck --impure --recreate-lock-file

.PHONY: update-lock-only
update-lock-only:
	nix flake update

.PHONY: os-switch
os-switch:
	sudo nixos-rebuild switch -I nixos-config=./nixos/configuration.nix

.PHONY: gc
gc:
	nix-collect-garbage

.PHONY: gc-all-gen
gc-all-gen:
	nix-collect-garbage -d
