.PHONY: ls-pkg
ls-pkg:
	home-manager packages

.PHONY: ls-gen
ls-gen:
	home-manager generations

.PHONY: fmt
fmt:
	nix fmt

.PHONY: switch
switch:
	home-manager switch --flake '.#tars' -b bck --impure

.PHONY: update
update:
	home-manager switch --flake '.#tars' -b bck --recreate-lock-file

.PHONY: update-lock-only
update-lock-only:
	nix flake update

.PHONY: gc
gc:
	nix-collect-garbage

.PHONY: gc-all-gen
gc-all-gen:
	nix-collect-garbage -d
