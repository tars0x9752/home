{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wezterm
  ];

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    
    return {
      font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Regular' }),
      font_size = 20,
      color_scheme = 'Mariana',
    }
  '';
}
