{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    keeweb
    firefox
  ];
}
