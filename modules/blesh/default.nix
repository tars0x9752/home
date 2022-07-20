{ pkgs, ... }:

# ble.sh 用の derivation
# https://github.com/akinomyoga/ble.sh

with pkgs;
let
  blesh = stdenv.mkDerivation {
    name = "blesh";
    # ただのシェルスクリプトなのでビルドとかは不要. ただ置くだけでよい.
    phases = [ "installPhase" ];
    src = fetchzip {
      url = "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20220712+1c7f7a1.tar.xz";
      sha256 = "1dlf07vbb7d28hlagxq2qn7afzxp7n2saxp69xajl0p03qsgpz9x";
    };
    # MEMO: $out/share に置いたやつは ~/.nix-profile/share から見える
    installPhase = ''
      mkdir -p $out/share/blesh
      cp -rv $src/* $out/share/blesh
    '';
  };
in
{
  home.packages = [ blesh ];

  #  ~/.local/share にインストールしたかったらこっち.
  # home.file.".local/share/blesh".source = blesh;

  home.file.".blerc".source = ./.blerc;
}
