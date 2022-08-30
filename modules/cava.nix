{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."cava/config".text = ''
    [color]

    gradient = 1
    gradient_count = 8
    gradient_color_1 = '#08D9D6'
    gradient_color_2 = '#2BC1C6'
    gradient_color_3 = '#4FA8B5'
    gradient_color_4 = '#7290A5'
    gradient_color_5 = '#957794'
    gradient_color_6 = '#B85F84'
    gradient_color_7 = '#DC4673'
    gradient_color_8 = '#FF2E63'
  '';
}
