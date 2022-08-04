{ pkgs, ... }:

{
  home.packages = with pkgs; [
    discord
    element-desktop
    firefox
    keeweb # configuration.nix で services.gnome.gnome-keyring.enable = true; が必要
    xfce.thunar
    lxappearance
    vscode
  ];

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
