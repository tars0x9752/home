{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [ cargo rustc gcc ];
    sessionPath = [ "$HOME/.cargo/bin" ];
  };
}
