{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    rnix-lsp
    nixpkgs-fmt
    nix-prefetch-git
    nix-prefetch-github

    # util
    coreutils
    binutils
    pciutils
    gawk
    gnumake
    gnused
    jo
    jq
    curl
    wget
    xsel
    xclip
    xdotool
    copyq
    gettext
    polkit_gnome
    unzip
    figlet

    # util replacement
    bat
    broot
    lsd
    ripgrep
    fd
    dua

    # media
    feh
    tty-clock
    maim
    zbar
    imagemagick
    qrencode

    # fm
    ranger

    # gemini
    amfora
  ];

  programs.fzf = {
    enable = true;
  };
}
