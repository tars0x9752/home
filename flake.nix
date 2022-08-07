{
  description = "Home Manager Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
        "figlet" =
          let
            drv = pkgs.figlet;
            exePath = "/bin/figlet";
          in
          {
            type = "app";
            program = "${drv}${exePath}";
          };
      };
    };
}
