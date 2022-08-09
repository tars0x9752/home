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
    ./neofetch.nix
    ./cava.nix
    ./cxxmatrix.nix
    ./rofi-power-menu.nix

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

    # Keyboard Input Method / 日本語入力
    ./i18n
  ];
}
