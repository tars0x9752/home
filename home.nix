{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tars";
  home.homeDirectory = "/home/tars";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
    pkgs.cowsay
  ];

  programs.git = {
    enable = true;

    userName = "tars0x9752";
    userEmail = "46079709+tars0x9752@users.noreply.github.com";

    aliases = {
      fix-commit = ''!git commit -F "$(git rev-parse --git-dir)/COMMIT_EDITMSG" --edit'';
      pushf = "push --force-with-lease";
      logs = "log --show-signature";
      ls-conf = "config --list --show-origin";
    };

    includes = [{ path = "~/.config/git/localconf"; }];

    extraConfig = {
      init = { defaultBranch = "main"; };
      branch = { sort = "-committerdate"; };
      core = {
        editor = "nvim";
      };
      pull.ff = "only";
    };
  };
}
