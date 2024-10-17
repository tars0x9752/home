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
    flake-parts.url = "github:hercules-ci/flake-parts";
    blesh = {
      url = "https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgsUnstable,
      home-manager,
      flake-parts,
      devshell,
      blesh,
      ...
    }:
    let
      hosts = {
        david-nixos = "david-nixos";
        lucy-macos = "lucy-macos";
      };
    in
    # https://flake.parts/
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      imports = [ inputs.devshell.flakeModule ];

      flake =
        let
          mkPkgsUnstable =
            system:
            import nixpkgsUnstable {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
        in
        {
          nixosConfigurations.${hosts.david-nixos} = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./nixos/configuration.nix ];
          };

          homeConfigurations.${hosts.david-nixos} = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "x86_64-linux"; };

            modules = [ ./hosts/david-nixos/home.nix ];

            extraSpecialArgs = {
              inherit blesh;
              pkgsUnstable = mkPkgsUnstable "x86_64-linux";
            };
          };

          homeConfigurations.${hosts.lucy-macos} = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { system = "aarch64-darwin"; };

            modules = [ ./hosts/lucy-macos/home.nix ];

            extraSpecialArgs = {
              inherit blesh;
              pkgsUnstable = mkPkgsUnstable "aarch64-darwin";
            };
          };
        };

      perSystem =
        {
          pkgs,
          system,
          inputs',
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run.html?highlight=apps.%3Csystem%3E#apps
          # https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone
          apps = {
            "activate/${hosts.david-nixos}" =
              let
                drv = self.outputs.homeConfigurations.${hosts.david-nixos}.activationPackage;
                exePath = "/activate";
              in
              {
                type = "app";
                program = "${drv}${exePath}";
              };

            "activate/${hosts.lucy-macos}" =
              let
                drv = self.outputs.homeConfigurations.${hosts.lucy-macos}.activationPackage;
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

          # https://flake.parts/options/devshell
          # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html
          # https://github.com/numtide/devshell
          devshells.default =
            { config, pkgs, ... }:
            {
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
                  name = "dev:install-${hosts.david-nixos}";
                  category = "Initial Setup";
                  help = "Install home-manager itself and apply the home configuration";
                  command = ''
                    export HOME_MANAGER_BACKUP_EXT=old
                    nix run '.#activate/${hosts.david-nixos}'
                    direnv allow
                  '';
                }
                {
                  name = "dev:install-${hosts.lucy-macos}";
                  category = "Initial Setup";
                  help = "Install home-manager itself and apply the home configuration";
                  command = ''
                    export HOME_MANAGER_BACKUP_EXT=old
                    nix run '.#activate/${hosts.lucy-macos}'
                  '';
                }

                # --- home-manager switch ---
                {
                  name = "dev:switch-${hosts.david-nixos}";
                  category = "Home";
                  help = "Switch home-manager to apply home config changes";
                  command = ''
                    home-manager switch --flake '.#${hosts.david-nixos}' -b bck --impure
                  '';
                }
                {
                  name = "dev:switch-${hosts.lucy-macos}";
                  category = "Home";
                  help = "Switch home-manager to apply home config changes";
                  command = ''
                    home-manager switch --flake '.#${hosts.lucy-macos}' -b bck --impure
                  '';
                }

                # --- home-manager ls ---
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

                # --- update ---
                {
                  name = "dev:update";
                  category = "Home";
                  help = "Update the flake lock file only";
                  command = ''
                    nix flake update
                    echo "plz switch after this"
                  '';
                }
                {
                  name = "dev:update-nixpkgs";
                  category = "Home";
                  help = "Update nixpkgs only";
                  command = ''
                    nix flake lock --update-input nixpkgs
                    echo "plz switch after this"
                  '';
                }

                # --- NixOS ---
                {
                  name = "dev:os-switch";
                  category = "NixOS";
                  help = "Switch nixos to rebuild and apply `configuration.nix` changes";
                  command = ''
                    sudo nixos-rebuild switch --flake '.#${hosts.david-nixos}' --impure
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
        };

    };
}
