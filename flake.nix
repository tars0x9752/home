{
  description = "Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";

    blesh = {
      url = "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, devshell, blesh, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;

        overlays = [ devshell.overlay ];
      };
      hostname = "tars";
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./nixos/configuration.nix ];
      };

      homeConfigurations.${hostname} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
        ];

        extraSpecialArgs = {
          inherit blesh;
        };
      };

      # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run.html?highlight=apps.%3Csystem%3E#apps
      # https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone
      apps.${system} = {
        "activate/${hostname}" =
          let
            drv = self.outputs.homeConfigurations.${hostname}.activationPackage;
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
    } //
    # currently my home configs support only x86_64-linux.
    # So eachDefaultSystem doesn't mean much, but it's harmless as it is & I want to remember flake-utils is a thing, so I'll leave it here.
    flake-utils.lib.eachDefaultSystem
      (system: {
        # Trying devShells and devshell as a better alternative to Makefile.
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
              name = "dev:install";
              category = "Initial Setup";
              help = "Install home-manager itself and apply the home configuration";
              command = ''
                export HOME_MANAGER_BACKUP_EXT=old
                nix run '.#activate/tars'
                direnv allow
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
      });
}
