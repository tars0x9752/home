{ ... }:

{
  imports = [
    # cli
    ./cli.nix
    ./git.nix
    ./starship.nix
    ./neovim.nix

    # shell
    ./bash
    ./blesh

    # dev
    ./node.nix
    ./rust.nix

    # font
    ./font.nix
  ];
}
