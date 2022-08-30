{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    
    return {
      font_size = 16,
      color_scheme = 'Framer (base16)',
      window_background_opacity = 0.85,
      hide_tab_bar_if_only_one_tab = true,
    }
  '';
}
