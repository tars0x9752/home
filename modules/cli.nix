{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    rnix-lsp
    nixpkgs-fmt

    # util
    coreutils
    binutils
    gawk
    gnumake
    gnused
    jo
    jq
    curl
    wget
    xsel
    xclip
    gettext
    polkit_gnome

    # util replacement
    bat
    broot
    lsd
    ripgrep
    fd
    fzf
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
