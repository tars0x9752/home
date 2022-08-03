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
    gh
    polkit_gnome

    # util replacement
    bat
    broot
    lsd
    ripgrep
    fd
    fzf
    dua

    # gemini
    amfora

    # other
    neofetch
    cowsay
    hello
  ];
}
