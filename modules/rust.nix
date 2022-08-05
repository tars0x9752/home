{ config, pkgs, ... }:

{
  home = {
    packages = [ pkgs.rustup ];
    sessionPath = [ "$HOME/.cargo/bin" ];
  };
}
