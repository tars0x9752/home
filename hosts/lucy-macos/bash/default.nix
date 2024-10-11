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

      # alias じゃない生のコマンドを叩く
      alias raw='command'

      bash:restart() {
        exec bash -l
      }

      cd:conf() {
        cd ~/.config
      }

      cd:git-top() {
        g:cd.top
      }

      template:ls() {
        nix flake show 'github:tars0x9752/templates'
      }

      template:metadata() {
        nix flake metadata 'github:tars0x9752/templates'
      }

      template:use() {
        if [[ -z "$1" ]]; then
          echo "a template name required."
        elif [[ -z "$2" ]]; then
          echo "a dir name required."
        else
          nix flake new "$2" -t "github:tars0x9752/templates#$1"          
        fi
      }
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;

  home.sessionPath = [ "${config.home.homeDirectory}/.config/bash/bin" ];
}
