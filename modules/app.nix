{ pkgs, pkgsUnstable, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    firefox
    pkgsUnstable.google-chrome
    xfce.thunar
    gimp
    lxappearance
    vscode
    screenkey
    vlc
  ];

  # to add SKIP_HOST_UPDATE (discord is not "pure")
  xdg.configFile."discord/settings.json".text = ''
    {
      "IS_MAXIMIZED": false,
      "IS_MINIMIZED": false,
      "WINDOW_BOUNDS": {
        "x": 2024,
        "y": 52,
        "width": 1995,
        "height": 1071
      },
      "BACKGROUND_COLOR": "#202225",
      "SKIP_HOST_UPDATE": true
    }
  '';

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "application/xhtml_xml" = "firefox.desktop";
      "image/webp" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
    };
  };
}
