{ pkgs, blesh, ... }:

# ble.sh 用の derivation
# https://github.com/akinomyoga/ble.sh

let
  drv = pkgs.stdenvNoCC.mkDerivation {
    name = "blesh";
    src = blesh;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/blesh
      cp -rv $src/* $out/share/blesh
    '';
  };
in
{
  home.packages = [ drv ];

  #  ~/.local/share にインストールしたかったらこっち.
  # home.file.".local/share/blesh".source = drv;

  home.file.".blerc".source = ./.blerc;
}
