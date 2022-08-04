{ ... }:

{
  imports = [
    # app
    ./app.nix

    # cli
    ./cli.nix
    ./git.nix
    ./gpg.nix
    ./neovim
    ./starship

    # shell
    ./bash
    ./blesh

    # wm
    ./rice.nix

    # term
    ./wezterm.nix

    # dev
    ./node
    ./rust.nix

    # font
    ./font.nix
  ];
}
