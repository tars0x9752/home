# home

**NixOS/Nix/Flakes | home-manager | i3wm | polybar | rofi | wezterm | bash with ble.sh**

My home nix configs/dotfiles with `home-manager`(standalone mode) and `configuration.nix`. Still a ways to go. (It will remain a work in progress forever.)

Basically, I let home-manager manage most of the stuff except NixOS system-specific settings. NixOS system-specific settings are in `configuration.nix`. If it's not NixOS you can simply use only the home-manager part.

> However, the home-manager part also uses user and environment specific settings (user names, device names and such), so it is necessary to make adjustments according to your environment.

## Initial set up

> NOTE: It assumes Nix Flakes feature is available.

### NixOS

- git clone and cd into this repository
- `make os-switch`
  - or manually do `sudo nixos-rebuild switch -I nixos-config=./nixos/configuration.nix`
- `make install` to install home-manager itself and apply the home configuration
- `reboot`

### Non-NixOS (x86_64-linux)

- [install nix](https://nixos.org/download.html#nix-install-linux)
- git clone and cd into this repository
- `make install` to install home-manager itself and apply the home configuration
- `reboot`

## Utility commands

### Switch

```sh
# to apply changes
make switch
```

It depends on what has changed but may need to restart i3wm or reboot the entire system.
(Restarting i3wm inplace is `$mod+Shift+r` and it will also restart polybar)

### (NixOS Only) OS Rebuild Switch

```sh
# (NixOS only) to apply `configuration.nix` changes
make os-switch
```

### Update

```sh
# may take a few minutes
make update
```

### Update the flake lock file only

```sh
make update-lock-only
```

### Garbage collection

```
make gc
```

### Delete old generations and garbage collection

```
make gc-all-gen
```

This frees up more disk space than `gc`, but it'll deletes all old generations. Don't use this if you don't understand what generation means.

### Others

read `Makefile`