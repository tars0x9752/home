{ ... }:

{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim/init.vim".source = ./init.vim;
}
