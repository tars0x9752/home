{ ... }:

{
  imports = [
    # cli
    ./cli.nix
    ./git.nix
    ./gpg.nix
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
