{ config, ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      # https://github.com/NixOS/nixpkgs/issues/148686
      # https://github.com/NixOS/nixpkgs/issues/3382
      export CURL_CA_BUNDLE=$SSL_CERT_FILE

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

      copy() {
        xsel -bi
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

      wifi:on() {
        nmcli radio wifi on
      }

      wifi:off() {
        nmcli radio wifi off
      }

      r:calc() {
        rofi -show calc -modi calc -no-show-match -no-sort
      }

      r:emoji() {
        rofi -modi emoji -show emoji
      }

      show:audio-visualizer() {
        cava
      }

      show:clock() {
        tty-clock -c -C 4
      }

      show:screenkey.start() {
        screenkey &
      }

      show:screenkey.end() {
        pkill screenkey
      }

      # screenshot
      img:screenshot() {
        if [[ -z "$1" ]]; then
          echo "a geometry required."
        elif [[ -z "$2" ]]; then
          echo "a file name required."
        else
          echo "Take a screenshot after 3 seconds."
          sleep 3
          maim -g $1 $2
        fi
      }

      img:screenshot-display1() {
        img:screenshot 1920x1080+1920+0 $1
      }

      img:screenshot-display2() {
        img:screenshot 1920x1080+0+0 $1
      }

      # QRコードを選択, デコードしてクリップボードにコピー
      qr:decode() {
        maim -qs | zbarimg -q --raw - | xclip -selection clipboard -f
      }

      # 文字列をQRコードに変換しターミナルに出力
      qr:encode() {
        qrencode -t ANSI $1
      }

      # 文字列をQRコードに変換しpngを生成 ($1: ファイル名, $2: 文字列)
      qr:encode-png() {
        qrencode -o $1 $2
      }

      cya() {
        systemctl poweroff
      }
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;

  home.sessionPath = [ "${config.home.homeDirectory}/.config/bash/bin" ];
}
