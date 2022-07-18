{ ... }:

{
  programs.starship = {
    enable = true;
  };

  # programs.starship.settings ではなく toml を直接使う. (そっちのほうが公式のjson schemaが使えて書きやすいので)
  xdg.configFile = {
    "starship.toml".source = ../xdg-conf/starship.toml;
  };
}
