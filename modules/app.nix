{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    firefox
    # keeweb # configuration.nix で services.gnome.gnome-keyring.enable = true; が必要
  ];
}
