{ pkgs, ... }:

{
  home.packages = with pkgs; [ wezterm ];

  # NOTE: 今のバージョンでは color_scheme のほうが colors より優先度が高いので scheme の色を上書きしたい場合は color_scheme を再定義する必要がある
  # NOTE: バージョンが 20220903 以上になったら colors が color_scheme より優先度高くなるので, 普通に colors で上書きする色を定義すればよくなる
  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'

    local my_framer = wezterm.color.get_builtin_schemes()['Framer (base16)']
    my_framer.cursor_fg = '#181818'
    my_framer.cursor_bg = '#EEEEEE'
    my_framer.compose_cursor = '#20BCFC'

    return {
      font_size = 16,
      window_background_opacity = 0.85,
      hide_tab_bar_if_only_one_tab = true,
      default_cursor_style = "BlinkingUnderline",
      cursor_blink_rate = 600,

      color_schemes = {
        ['My Framer'] = my_framer,
      },

      color_scheme = 'My Framer',
    }
  '';
}

# https://github.com/jssee/base16-framer-scheme
# base00: "#181818" # black
# base01: "#151515" # ----
# base02: "#464646" # ---
# base03: "#747474" # --
# base04: "#B9B9B9" # ++
# base05: "#D0D0D0" # +++
# base06: "#E8E8E8" # ++++
# base07: "#EEEEEE" # white
# base08: "#FD886B" # orange
# base09: "#FC4769" # red
# base0A: "#FECB6E" # yellow
# base0B: "#32CCDC" # green
# base0C: "#ACDDFD" # cyan
# base0D: "#20BCFC" # blue
# base0E: "#BA8CFC" # purple
# base0F: "#B15F4A" # brown
