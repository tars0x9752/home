{ ... }:

{
  imports = [
    # cli
    ./cli.nix
    ./git.nix
    ./neovim
    ./starship

    # shell
    ./bash
    ./blesh

    # dev
    ./node
    ./rust.nix

    # font
    ./font.nix
  ];
}
