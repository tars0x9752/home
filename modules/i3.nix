{ config, lib, pkgs, ... }:

{

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
          smartGaps = true;
        };

        menu = "${config.programs.rofi.package}/bin/rofi -show drun";

        terminal = "wezterm";

        startup = [
          { command = "systemctl --user restart polybar"; always = true; notification = false; }
          { command = "xset r rate 200 30"; always = true; notification = false; }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = true; notification = false; }
        ];

        # polybar を使うので i3bar は不要
        bars = [ ];

        defaultWorkspace = "workspace number 1";

        colors = {
          focused = {
            text = "#000000"; # タイトルのテキスト
            background = "#08D9D6"; # タイトルの背景
            border = "#08D9D6"; # タイトルのボーダー
            childBorder = "#08D9D6"; # window全体のボーダー
            indicator = "#ff2e63"; # vertical / horizontal のアレ
          };

          # コンテナの中に複数windowがあって, そのなかの最後にフォーカスされてたもの
          focusedInactive = {
            text = "#F1FAEE"; # タイトルのテキスト
            background = "#047672"; # タイトルの背景
            border = "#047672"; # タイトルのボーダー
            childBorder = "#047672"; # window全体のボーダー
            indicator = "#ff2e63"; # vertical / horizontal のアレ
          };

          unfocused = {
            text = "#F1FAEE"; # タイトルのテキスト
            background = "#252a34"; # タイトルの背景
            border = "#252a34"; # タイトルのボーダー
            childBorder = "#252a34"; # window全体のボーダー
            indicator = "#ff2e63"; # vertical / horizontal のアレ
          };
        };

        window.border = 1; # 新規作成した window にのみ有効
      };
    };
  };

  # rofi
  programs.rofi = {
    enable = true;

    package = with pkgs; rofi.override { plugins = [ rofi-calc rofi-emoji ]; };
  };

  # picom
  services.picom = {
    enable = true;
  };

  # polybar
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      pulseSupport = true;
      iwSupport = true;
      # githubSupport = true;
    };

    config = {
      "colors" = {
        background = "#252a34";
        background-alt = "#3b4354";
        foreground = "#F1FAEE";
        primary = "#08D9D6";
        secondary = "#047672";
        alert = "#ff2e63";
        disabled = "#707880";
      };

      "bar/top" = {
        width = "100%";
        height = "24pt";
        radius = 6;

        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        line-size = "3pt";

        border-size = "4pt";
        border-color = "#00000000";

        padding-left = 0;
        padding-right = 1;

        module-margin = 1;

        separator = "|";
        separator-foreground = "\${colors.disabled}";

        font-0 = "JetBrainsMono Nerd Font:style=Regular:size=16;5";

        modules-left = "xworkspaces xwindow";
        modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan date battery";

        cursor-click = "pointer";
        cursor-scroll = "ns-resize";

        enable-ipc = true;
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline = "\${colors.primary}";
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-foreground = "\${colors.disabled}";
        label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };

      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount-0 = "/";
        label-mounted = "%{F#08D9D6} %mountpoint%%{F-} %percentage_used%%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.disabled}";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

        sink = "alsa_output.pci-0000_00_1f.3.analog-stereo"; # 違うsinkや違うマシンで使う場合は要変更

        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";

        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";

        label-layout = "%layout%";
        label-layout-foreground = "\${colors.primary}";

        label-indicator-padding = 2;
        label-indicator-margin = 1;
        label-indicator-foreground = "\${colors.background}";
        label-indicator-background = "\${colors.secondary}";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = "RAM ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage_used:2%%";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "CPU ";
        format-prefix-foreground = "\${colors.primary}";
        label = "%percentage:2%%";
      };

      "module/wlan" = {
        type = "internal/network";
        interval = 5;
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        label-disconnected = "睊 wifi off";
        interface-type = "wireless";
        label-connected = "直 wifi on";
        label-connected-foreground = "\${colors.primary}";
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";
        label = "%date%";
        label-foreground = "\${colors.primary}";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT1";
        adapter = "ACAD";
        full-at = 99;
        format-charging = "<label-charging>";
        format-charging-foreground = "\${colors.primary}";
        format-charging-background = "\${colors.background}";
        format-full = "<label-full>";
        format-full-foreground = "\${colors.primary}";
        format-full-background = "\${colors.background}";
        format-discharging = "<label-discharging>";
        format-discharging-foreground = "\${colors.primary}";
        format-discharging-background = "\${colors.background}";
        label-charging = "  %percentage%% ";
        label-discharging = "  %percentage%% ";
        label-discharging-foreground = "\${colors.primary}";
        label-full = "  %percentage%% ";
      };


      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };

    script = "polybar top &";
  };
}
