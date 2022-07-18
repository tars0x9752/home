{ ... }:

{
  programs.neovim = {
    enable = true;
  };
  
  xdg.configFile."nvim/init.vim".source = ../configs/nvim/init.vim;
}
