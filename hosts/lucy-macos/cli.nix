{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # nix
    nil
    nixfmt-rfc-style
    nix-prefetch-git
    nix-prefetch-github
    nix-du

    # util replacement
    broot
    lsd
    ripgrep
    fd
    dua

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
