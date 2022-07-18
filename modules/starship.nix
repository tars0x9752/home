{ ... }:

{
  programs.starship = {
    enable = true;

    # default で true だけ一応
    enableBashIntegration = true;
  };

  # programs.starship.settings ではなく toml を直接使う. (そっちのほうが公式のjson schemaが使えて書きやすいので)
  xdg.configFile."starship.toml".source = ../configs/starship.toml;
}
