{ config, ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      source ~/.config/bash/init.bash

      source ~/.config/bash/git-functions.bash

      # Nix で管理しないローカル用 init ファイル
      if [[ -e ~/.config/bash/local-init.bash ]]; then
        source ~/.config/bash/local-init.bash
      fi
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;

  xdg.configFile."bash/bin".source = ./bin;

  home.sessionPath = [ "${config.home.homeDirectory}/.config/bash/bin" ];
}
