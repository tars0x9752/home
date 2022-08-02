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
          size = 18.0;
        };

        gaps = {
          inner = 10;
          smartGaps = true;
        };

        menu = "${config.programs.rofi.package}/bin/rofi -show drun";

        startup = [
          { command = "systemctl --user restart polybar"; always = true; notification = false; }
          { command = "xset r rate 200 30"; always = true; notification = false; }
        ];
      };
    };
  };

  # rofi
  programs.rofi = {
    enable = true;

    package = with pkgs; rofi.override { plugins = [ rofi-calc rofi-emoji ]; };
  };

  # polybar
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      # alsaSupport = true;
      # githubSupport = true;
    };

    config = {
      "bar/top" = {
        width = "100%";
        height = "3%";
        radius = 5;
        modules-center = "date";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%y-%m-%d";
        time = "%H:%M";
        label = "%time%  %date%";
      };
    };

    script = "polybar top &";
  };
}
