{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    keeweb # configuration.nix で services.gnome.gnome-keyring.enable = true; が必要
    firefox
  ];
}
