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

  # nix store は immutable なので npm i -g は上で定義した globalNodeModules にインストールするようにする
  home.file.".npmrc".text = "prefix = ${globalNodeModules}";

  home.sessionPath = [ "${globalNodeModules}/bin" ];
}
