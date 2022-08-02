{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    
    return {
      font_size = 20,
      color_scheme = 'Molokai',
      window_background_opacity = 0.8,
    }
  '';
}