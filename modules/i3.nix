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
          inner = 10;
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
      # githubSupport = true;
    };

    config = {
      "colors" = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#F0C674";
        secondary = "#8ABEB7";
        alert = "#A54242";
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

        font-0 = "JetBrainsMono Nerd Font:style=Regular:size=16";

        modules-left = "xworkspaces xwindow";
        modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan date";

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
        label-mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.disabled}";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";

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
        label-disconnected = "%{F#F0C674}%ifname%%{F#707880} disconnected";
        interface-type = "wireless";
        label-connected = "%{F#F0C674}%ifname%%{F-}"; # %essid% %local_ip%
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";
        label = "%date%";
        label-foreground = "\${colors.primary}";
      };

      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };

    script = "polybar top &";
  };
}
