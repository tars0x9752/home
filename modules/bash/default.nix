{ config, ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      source "$HOME/.config/bash/init.bash"
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;

  xdg.configFile."bash/bin".source = ./bin;

  home.sessionPath = [ "${config.home.homeDirectory}/.config/bash/bin" ];
}
