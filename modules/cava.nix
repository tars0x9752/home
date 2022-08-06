{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cava
  ];

  xdg.configFile."cava/config".text = ''
    [color]

    gradient = 1
    gradient_count = 8
    gradient_color_1 = '#4cc9f0'
    gradient_color_2 = '#4895ef'
    gradient_color_3 = '#4361ee'
    gradient_color_4 = '#3f37c9'
    gradient_color_5 = '#480ca8'
    gradient_color_6 = '#7209b7'
    gradient_color_7 = '#b5179e'
    gradient_color_8 = '#f72585'
  '';
}
