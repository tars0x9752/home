{ config, lib, pkgs, ... }:

let
  colors = {
    # general
    background = "#252a34";
    background-alt = "#3b4354";
    foreground = "#F1FAEE";
    primary = "#08D9D6";
    secondary = "#047672";
    alert = "#ff2e63";
    disabled = "#707880";

    # rofi
    bg0 = "#242424E6";
    bg1 = "#7E7E7E80";
    bg2 = "#0860f2E6";
    fg0 = "#DEDEDE";
    fg1 = "#FFFFFF";
    fg2 = "#DEDEDE80";
  };
in
{
  # wallpaper
  xdg.configFile."wallpaper/wallpaper.jpg".source = ../wallpaper/cube.jpg;

  xsession = {
    enable = true;

    scriptPath = ".hm-xsession";

    # i3-gaps
    windowManager.i3 = {
      enable = true;

      package = pkgs.i3-gaps;

      config = {
        modifier = "Mod4"; # is Super

        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 16.0;
        };

        gaps = {
          inner = 20;
          # smartGaps = true;
          smartBorders = "on";
        };

        menu = "${config.programs.rofi.package}/bin/rofi -show drun";

        terminal = "wezterm";

        floating.criteria = [{ class = "Pavucontrol"; }];

        startup = [
          { command = "systemctl --user restart polybar"; always = true; notification = false; }
          { command = "xset r rate 200 30"; always = true; notification = false; }
          { command = "xrandr --output eDP-1-1 --auto --left-of HDMI-0"; notification = false; }
          {
            command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.feh}/bin/feh --bg-scale ${config.xdg.configHome}/wallpaper/wallpaper.jpg";
            always = true;
            notification = false;
          }
        ];

        # polybar を使うので i3bar は不要
        bars = [ ];

        defaultWorkspace = "workspace number 1";

        keybindings =
          let
            modifier = config.xsession.windowManager.i3.config.modifier;
          in
          lib.mkOptionDefault {
            "${modifier}+c" = ''exec --no-startup-id "rofi -show calc -modi calc -no-show-match -no-sort > /dev/null"'';
          };

        colors = {
          focused = {
            text = colors.primary; # タイトルのテキスト
            background = colors.background-alt; # タイトルの背景
            border = colors.primary; # タイトルのボーダー
            childBorder = colors.primary; # window全体のボーダー
            indicator = colors.alert; # vertical / horizontal のアレ
          };

          # コンテナの中に複数windowがあって, そのなかの最後にフォーカスされてたもの
          focusedInactive = {
            text = colors.foreground; # タイトルのテキスト
            background = colors.background-alt; # タイトルの背景
            border = colors.background-alt; # タイトルのボーダー
            childBorder = colors.secondary; # window全体のボーダー
            indicator = colors.alert; # vertical / horizontal のアレ
          };

          unfocused = {
            text = colors.foreground; # タイトルのテキスト
            background = colors.background; # タイトルの背景
            border = colors.background; # タイトルのボーダー
            childBorder = colors.background; # window全体のボーダー
            indicator = colors.alert; # vertical / horizontal のアレ
          };
        };

        window.border = 1; # 新規作成した window にのみ有効

        workspaceOutputAssign = [{ output = "eDP-1-1"; workspace = "10"; }];
      };

      extraConfig = ''for_window [all] title_window_icon padding 10px'';
    };
  };

  # picom
  services.picom = {
    enable = true;
  };

  # rofi
  programs.rofi = {
    enable = true;

    package = with pkgs; rofi.override { plugins = [ rofi-calc rofi-emoji ]; };

    extraConfig = {
      show-icons = true;
      modi = "drun,emoji";
    };

    theme =
      let
        mkL = config.lib.formats.rasi.mkLiteral;
      in
      {
        "*" = {
          bg0 = mkL colors.bg0;
          bg1 = mkL colors.bg1;
          bg2 = mkL colors.bg2;
          fg0 = mkL colors.fg0;
          fg1 = mkL colors.fg1;
          fg2 = mkL colors.fg2;

          background-color = mkL "transparent";
          text-color = mkL "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        window = {
          background-color = mkL "@bg0";
          location = mkL "center";
          width = 640;
          y-offset = -200;
          border-radius = 8;
        };

        inputbar = {
          padding = mkL "12px";
          spacing = mkL "12px";
          children = map mkL [ "icon-search" "entry" ];
        };

        icon-search = {
          expand = false;
          filename = "search";
          size = mkL "28px";
          vertical-align = mkL "0.5";
        };

        entry = {
          placeholder = "Search";
          placeholder-color = mkL "@fg2";
          vertical-align = mkL "0.5";
        };

        message = {
          border = mkL "2px 0 0";
          border-color = mkL "@bg1";
          background-color = mkL "@bg1";
        };

        textbox = {
          padding = mkL "8px 24px";
        };

        listview = {
          lines = 10;
          columns = 1;
          fixed-height = false;
          border = mkL "1px 0 0";
          border-color = mkL "@bg1";
        };

        element = {
          padding = mkL "8px 16px";
          spacing = mkL "16px";
          background-color = mkL "transparent";
        };

        element-icon = {
          size = mkL "1em";
          vertical-align = mkL "0.5";
        };

        element-text = {
          text-color = mkL "inherit";
          vertical-align = mkL "0.5";
        };

        "element normal active" = {
          text-color = mkL "@bg2";
        };

        "element selected normal" = {
          background-color = mkL "@bg2";
          text-color = mkL "@fg1";
        };

        "element selected active" = {
          background-color = mkL "@bg2";
          text-color = mkL "@fg1";
        };
      };
  };

  # polybar
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      iwSupport = true;
    };

    config =
      let
        pulseaudio-control = "${pkgs.callPackage ./pulseaudio-control.nix { } }/bin/pulseaudio-control";
      in
      {
        "global/wm" = {
          margin-bottom = 0;
          margin-top = 0;
        };

        "bar/main" = {
          monitor = "HDMI-0";

          width = "100%";
          height = 40;

          background = "${colors.background}";
          foreground = "${colors.foreground}";

          # underline / overline
          line-size = 2;
          line-color = "${colors.primary}";

          border-size = 0;

          padding = 0;

          module-margin = 1;

          font-0 = "JetBrainsMono Nerd Font:style=Regular:size=14;4";

          modules-left = "oslogo xworkspaces xwindow";
          modules-right = "pulseaudio-control-output filesystem memory cpu wlan battery date";

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";

          enable-ipc = true;
        };

        "bar/side" = {
          "inherit" = "bar/main";

          monitor = "eDP-1-1";
        };

        "module/oslogo" = {
          type = "custom/text";
          content = " NixOS";
          content-foreground = "${colors.background}";
          content-background = "${colors.primary}";
          content-padding = 2;
        };

        "module/xworkspaces" = {
          type = "internal/xworkspaces";
          pin-workspaces = true;
          enable-scroll = false;
          icon-0 = "10;";
          icon-1 = "1;";
          icon-2 = "2;";
          icon-3 = "3;";
          icon-4 = "4;";
          icon-5 = "5;";
          icon-6 = "6;";
          icon-7 = "7;";
          icon-8 = "8;";
          icon-9 = "9;";
          icon-default = "";

          format = "<label-state>";

          label-active = "%icon%";
          label-active-foreground = "${colors.primary}";
          label-active-background = "${colors.background-alt}";
          label-active-underline = "${colors.primary}";

          label-occupied = "%icon%";

          label-urgent = "%icon%";
          label-urgent-foreground = "${colors.alert}";

          label-empty = "%icon%";
          label-empty-foreground = "${colors.disabled}";

          label-active-padding = 2;
          label-occupied-padding = 2;
          label-urgent-padding = 2;
          label-empty-padding = 2;
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:40:...%";
          format = "<label>";
          format-prefix = "  ";
          format-prefix-foreground = "${colors.primary}";
          label-empty = "NixOS";
        };

        "module/filesystem" = {
          type = "internal/fs";
          interval = 25;
          mount-0 = "/";
          label-mounted = "%{F${colors.primary}}DISK:%{F-} %percentage_used:2%%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "${colors.disabled}";
        };

        "module/pulseaudio-control-output" = {
          type = "custom/script";
          tail = true;

          # 必要に応じて nickname および sink や source 名(node名)を変更すること
          exec = ''${pulseaudio-control} --icons-volume "%{F${colors.primary}} %{F-},%{F${colors.primary}} %{F-}" --icon-muted "%{F${colors.disabled}} %{F-}" --node-nicknames-from "device.profile.name" --node-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo:speakers " listen'';
          click-right = "exec ${pkgs.pavucontrol}/bin/pavucontrol &";
          click-left = "${pulseaudio-control} togmute";
          click-middle = "${pulseaudio-control} next-node";
          scroll-up = "${pulseaudio-control} --volume-max 130 up";
          scroll-down = "${pulseaudio-control} --volume-max 130 down";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "RAM: ";
          format-prefix-foreground = "${colors.primary}";
          label = "%percentage_used:2%%";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "CPU: ";
          format-prefix-foreground = "${colors.primary}";
          label = "%percentage:2%%";
        };

        "module/wlan" = {
          type = "internal/network";
          interval = 5;
          interface-type = "wireless";
          format-connected = "<label-connected>";
          format-disconnected = "<label-disconnected>";
          label-connected = "on";
          label-disconnected = "off";
          format-connected-prefix = "直 ";
          format-connected-prefix-foreground = "${colors.primary}";
          format-disconnected-prefix = "睊 ";
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;
          date = "%Y-%m-%d %H:%M";
          label = "%date%";
          format = "<label>";
          format-prefix = " ";
          format-foreground = "${colors.background}";
          format-background = "${colors.primary}";
          format-padding = 2;
        };

        "module/battery" = {
          type = "internal/battery";
          # ls -1 /sys/class/power_supply/
          battery = "BAT1";
          adapter = "ACAD";

          label-charging = "%percentage%%";
          label-discharging = "%percentage%%";
          label-full = "%percentage%%";
          format-charging = "<label-charging>";
          format-discharging = "<label-discharging>";
          format-full = "<label-full>";
          format-charging-prefix = " ";
          format-discharging-prefix = " ";
          format-full-prefix = " ";
          format-charging-prefix-foreground = "${colors.primary}";
          format-discharging-prefix-foreground = "${colors.primary}";
          format-full-prefix-foreground = "${colors.primary}";
        };

        "settings" = {
          screenchange-reload = true;
          pseudo-transparency = true;
        };
      };

    script = ''
      polybar --reload main &
      polybar --reload side &
    '';
  };
}
