{ config, pkgs, ... }:


let
  inherit (config.home) homeDirectory;
in
let
  globalNodeModules = "${homeDirectory}/.node_modules_global";
in
{
  home.packages = [
    pkgs.nodejs
  ];

  home.file.".bash_completion.d/npm-completion".source = ./npm-completion.bash;

  # nix store は immutable なので npm i -g は上で定義した globalNodeModules にインストールするようにする
  home.file.".npmrc".text = "prefix = ${globalNodeModules}";

  home.sessionPath = [ "${globalNodeModules}/bin" ];
}
