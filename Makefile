.PHONY: hello
hello:
	nix develop -c hello

.PHONY: ls-pkg
ls-pkg:
	nix develop -c ls-pkg

.PHONY: ls-gen
ls-gen:
	nix develop -c ls-gen

.PHONY: fmt
fmt:
	nix develop -c fmt

.PHONY: install
install:
	nix develop -c install

.PHONY: switch
switch:
	nix develop -c switch

.PHONY: update
update:
	nix develop -c update

.PHONY: update-lock-only
update-lock-only:
	nix develop -c update-lock-only

.PHONY: os-switch
os-switch:
	nix develop -c os-switch

.PHONY: gc
gc:
	nix develop -c gc

.PHONY: gc-all-gen
gc-all-gen:
	nix develop -c gc-all-gen
