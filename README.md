# home

**NixOS/Nix/Flakes | home-manager | i3wm | polybar | rofi | wezterm | bash with ble.sh**

My home nix configs/dotfiles with `home-manager`(standalone mode) and `configuration.nix`. Still a ways to go. (It will remain a work in progress forever.)

Basically, I let home-manager manage most of the stuff except NixOS system-specific settings. NixOS system-specific settings are in `configuration.nix`. If it's not NixOS you can simply use only the home-manager part.

> However, the home-manager part also uses user and environment specific settings (user names, device names and such), so it is necessary to make adjustments according to your environment.

## Screenshots

<a href="./screenshots/home.png"><img src="./screenshots/home.png" height="700" ></a>

## Initial set up

> NOTE: It assumes Nix Flakes feature is available.

### NixOS

- git clone and cd into this repository
- `nix develop -c os-switch`
- `nix develop -c install` to install home-manager itself and apply the home configuration
- `reboot`

### Non-NixOS (x86_64-linux)

- [install nix](https://nixos.org/download.html#nix-install-linux)
  - `sh <(curl -L https://nixos.org/nix/install) --daemon`
- git clone and cd into this repository
- `nix develop -c install` to install home-manager itself and apply the home configuration
- `reboot`

## Utility commands

> NOTE: At first I used Makefile for these commands, but now I've added the devShell commands as well. So you can also use `nix develop` and the devShell commands instead of make. Run `nix develop` then `menu` to see available devShell commands. 


**EDIT:** Now, I've completely switched to devShell commands instead of make.

The following commands are assumed to be used in `nix develop` shell. Auto-completion should work to help you type commands.

Run `nix develop` first or use direnv instead. There's `nix-direnv` integration in this configs so no need to `nix develop` manually every time. (If `direnv` is already enabled, it will automatically run `nix develop` when you cd to this directory.  You need to run `direnv allow` if it's not enabled yet.)

### Show menu

Show all available devShell commands.

```sh
menu
```

### Switch

```sh
dev:switch
```

It depends on what has changed but may need to restart i3wm or reboot the entire system.
(Restarting i3wm inplace is `$mod+Shift+r` and it will also restart polybar)

### (NixOS Only) OS Rebuild Switch

```sh
dev:os-switch
```

### Update all home-manager inputs

```sh
dev:update
```

### Update nixpkgs only

```sh
dev:update-nixpkgs
```

### Garbage collection

```sh
# normal garbage collection
dev:gc

# delete all generations older than 5 days
dev:gc-stale

# delete all old generations
dev:gc-all
```

`dev:gc-all` frees up more disk space than `dev:gc`, but it'll deletes all old generations of all profiles. Don't use this if you don't understand what it means since this makes rollbacks to previous configurations impossible.

### Others

read `flake.nix`
