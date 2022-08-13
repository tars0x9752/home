{ pkgs, blesh, ... }:

# ble.sh 用の derivation
# https://github.com/akinomyoga/ble.sh

let
  drv = pkgs.stdenvNoCC.mkDerivation {
    name = "blesh";
    src = blesh;
    dontBuild = true;

    # see https://discourse.nixos.org/t/nix-print-dev-env-command-shows-some-assinments-to-readonly-variables/20916
    patches = [ ./blesh.patch ];

    installPhase = ''
      mkdir -p "$out/share/lib"

      cat <<EOF >"$out/share/lib/_package.sh"
      _ble_base_package_type=nix
      function ble/base/package:nix/update {
        echo "Use Nix to update" >&2
        return 1
      }
      EOF

      cp -rv ./* $out/share

      runHook postInstall
    '';

    postInstall = ''
      mkdir -p "$out/bin"
      cat <<EOF >"$out/bin/blesh-path"
      #!${pkgs.runtimeShell}
      # Run this script to find the ble.sh shared folder
      # where all the shell scripts are living.
      echo "$out/share/ble.sh"
      EOF
      chmod +x "$out/bin/blesh-path"
    '';
  };
in
{
  home.packages = [ drv ];

  home.file.".blerc".source = ./.blerc;
}
