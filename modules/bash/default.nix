{ ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      source "$HOME/.config/bash/init.bash"
    '';
  };

  xdg.configFile."bash/init.bash".source = ./init.bash;
}
