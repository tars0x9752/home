{ ... }:

{
  programs.starship = {
    enable = true;

    # default で true だけど明示的に書いとく
    enableBashIntegration = true;
  };

  # programs.starship.settings ではなく toml を直接使う. (そっちのほうが公式のjson schemaが使えて書きやすいので)
  xdg.configFile."starship.toml".source = ./starship.toml;
}
