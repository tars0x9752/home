{ config, pkgs, ... }:

let
  inherit (config.home) homeDirectory;
  globalNodeModules = "${homeDirectory}/.node_modules_global";
in
{
  home.packages = [ pkgs.nodejs ];

  home.file.".bash_completion.d/npm-completion".source = ./npm-completion.bash;

  # nix store は immutable なので npm i -g は上で定義した globalNodeModules にインストールするようにする
  home.file.".npmrc".text = "prefix = ${globalNodeModules}";

  home.sessionPath = [ "${globalNodeModules}/bin" ];

  programs.bash.initExtra = ''
    # nix-shell + bun の shebang をつけて shellscript のようにそのまま実行できるtsファイルを作成する
    # 引数としてファイル名が必要
    ts:init-script() {
    if [[ -z "$1" ]]; then
      echo "file name required"
    else
    cat << EOF > "$1"
    #! /usr/bin/env nix-shell
    /*
    #! nix-shell -i bun -p bun
    */

    console.log("hello world")
    EOF
    chmod +x "$1"
    fi
    }
  '';
}
