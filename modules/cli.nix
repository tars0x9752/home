{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    # rnix-lsp # 'rnix-lsp' has been removed as it is unmaintained
    nixpkgs-fmt
    nix-prefetch-git
    nix-prefetch-github
    nix-du

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
    protobuf

    # util replacement
    broot
    lsd
    ripgrep
    fd
    dua

    # ditrobox
    distrobox

    # media
    feh
    tty-clock
    maim
    zbar
    imagemagick
    qrencode
    ffmpeg_5-full
    graphviz

    # fm
    ranger

    # gemini
    amfora
  ];

  programs.fzf = {
    enable = true;
  };

  programs.bat = {
    enable = true;

    config = {
      theme = "base16";
    };
  };
}
