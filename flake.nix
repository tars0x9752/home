{
  description = "Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable"; # for latest
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    blesh = {
      url = "https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgsUnstable,
      home-manager,
      flake-utils,
      devshell,
      blesh,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlays.default ];
        };

        pkgsUnstable = import nixpkgsUnstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        hosts = {
          david-nixos = "david-nixos";
          lucy-macos = "lucy-macos";
        };
      in
      {
        formatter = pkgs.nixfmt-rfc-style;

        nixosConfigurations.${hosts.david-nixos} = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./nixos/configuration.nix ];
        };

        homeConfigurations.${hosts.david-nixos} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./hosts/david-nixos/home.nix ];

          extraSpecialArgs = {
            inherit blesh;
            inherit pkgsUnstable;
          };
        };

        homeConfigurations.${hosts.lucy-macos} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [ ./hosts/lucy-macos/home.nix ];

          extraSpecialArgs = {
            inherit blesh;
            inherit pkgsUnstable;
          };
        };

        # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run.html?highlight=apps.%3Csystem%3E#apps
        # https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone
        apps = {
          "activate/${hosts.david-nixos}" =
            let
              drv = self.outputs.homeConfigurations.${system}.${hosts.david-nixos}.activationPackage;
              exePath = "/activate";
            in
            {
              type = "app";
              program = "${drv}${exePath}";
            };

          "activate/${hosts.lucy-macos}" =
            let
              drv = self.outputs.homeConfigurations.${system}.${hosts.lucy-macos}.activationPackage;
              exePath = "/activate";
            in
            {
              type = "app";
              program = "${drv}${exePath}";
            };

          # just for fun
          "figlet" = {
            type = "app";
            program = "${pkgs.figlet}/bin/figlet";
          };
        };

        # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html
        # https://github.com/numtide/devshell
        devShells.default = pkgs.devshell.mkShell {
          devshell.motd = ''
            {bold}{14}🔨 My home conigs 🔨{reset}
            $(type -p menu &>/dev/null && menu)
          '';

          commands = [
            # --- Fun ---
            {
              name = "dev:hello";
              category = "Fun";
              help = "Print a nice hello world";
              command = ''
                nix run '.#figlet' -- -f isometric1 -c "Hello World"
              '';
            }

            # --- Initial Setup ---
            {
              name = "dev:install-david-nixos";
              category = "Initial Setup";
              help = "Install home-manager itself and apply the home configuration";
              command = ''
                export HOME_MANAGER_BACKUP_EXT=old
                nix run '.#activate/david-nixos'
                direnv allow
              '';
            }

            {
              name = "dev:install-lucy-macos";
              category = "Initial Setup";
              help = "Install home-manager itself and apply the home configuration";
              command = ''
                export HOME_MANAGER_BACKUP_EXT=old
                nix run '.#activate/lucy-macos'
              '';
            }

            # --- Home Environment ---
            {
              name = "dev:ls-pkg";
              category = "Home";
              help = "List all packages installed in home-manager-path";
              command = ''
                home-manager packages
              '';
            }
            {
              name = "dev:ls-gen";
              category = "Home";
              help = "List all home environment generations";
              command = ''
                home-manager generations
              '';
            }
            {
              name = "dev:switch";
              category = "Home";
              help = "Switch home-manager to apply home config changes";
              command = ''
                home-manager switch --flake '.#tars' -b bck --impure
              '';
            }
            {
              name = "dev:update";
              category = "Home";
              help = "Update things";
              command = ''
                home-manager switch --flake '.#tars' -b bck --impure --recreate-lock-file
              '';
            }
            {
              name = "dev:update-nixpkgs";
              category = "Home";
              help = "Update nixpkgs only";
              command = ''
                nix flake lock --update-input nixpkgs
                dev:switch
              '';
            }
            {
              name = "dev:update-lock-only";
              category = "Home";
              help = "Update the flake lock file only";
              command = ''
                nix flake update
              '';
            }

            # --- NixOS ---
            {
              name = "dev:os-switch";
              category = "NixOS";
              help = "Switch nixos to rebuild and apply `configuration.nix` changes";
              command = ''
                sudo nixos-rebuild switch --flake '.#tars' --impure
              '';
            }
            {
              name = "dev:os-ls-gen";
              category = "NixOS";
              help = "List all nixos generations";
              command = ''
                sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
              '';
            }

            # --- Utility ---
            {
              name = "dev:fmt";
              category = "Utility";
              help = "Format nix files";
              command = ''
                nix fmt
              '';
            }
            {
              name = "dev:du-svg";
              category = "Utility";
              help = "Show what gc-roots are taking space (svg)";
              command = ''
                nix-du -s=500MB | tred | dot -Tsvg > store.svg
              '';
            }
            {
              name = "dev:du-png";
              category = "Utility";
              help = "Show what gc-roots are taking space (png)";
              command = ''
                nix-du -s=500MB | tred | dot -Tpng > store.png
              '';
            }
            {
              name = "dev:show-gc-roots";
              category = "Utility";
              help = "Show gc-roots";
              command = ''
                nix-store --gc --print-roots
              '';
            }
            {
              name = "dev:gc";
              category = "Utility";
              help = "Garbage collection";
              command = ''
                sudo nix-collect-garbage
              '';
            }
            {
              name = "dev:gc-stale";
              category = "Utility";
              help = ''Perform garbage collection and delete all generations older than 5 days'';
              command = ''
                sudo nix-collect-garbage -d --delete-older-than 5d
              '';
            }
            {
              name = "dev:gc-all";
              category = "Utility";
              help = ''Perform garbage collection and delete all old generations'';
              command = ''
                sudo nix-collect-garbage -d
              '';
            }
          ];
        };
      }
    );
}
