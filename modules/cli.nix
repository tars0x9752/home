{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    rnix-lsp
    nixpkgs-fmt

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

    # util replacement
    bat
    broot
    lsd
    ripgrep
    fd
    dua

    # media
    cava
    feh

    # fm
    ranger

    # gemini
    amfora
  ];

  programs.fzf = {
    enable = true;
  };
}
