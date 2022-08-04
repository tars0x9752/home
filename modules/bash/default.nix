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

      bash:restart() {
        exec bash -l
      }

      cd:conf() {
        cd ~/.config
      }

      cd:git-top() {
        g:cd.top
      }

      copy() {
        xsel -bi
      }

      cya() {
        shutdown -h now
      }
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;

  xdg.configFile."bash/bin".source = ./bin;

  home.sessionPath = [ "${config.home.homeDirectory}/.config/bash/bin" ];
}
