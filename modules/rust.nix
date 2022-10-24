{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      rustup
      gcc
    ];
    sessionPath = [ "$HOME/.cargo/bin" ];
  };
}
