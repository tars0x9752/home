{ ... }:

# alias 等は補完効かないのでここでは指定しない. git-functions.bash 参照

{
  programs.git = {
    enable = true;

    userName = "tars0x9752";
    userEmail = "46079709+tars0x9752@users.noreply.github.com";

    includes = [{ path = "~/.config/git/localconf"; }];

    signing = {
      key = "7F507F37EDAA9907";
      signByDefault = true;
    };

    extraConfig = {
      init = { defaultBranch = "main"; };
      branch = { sort = "-committerdate"; };
      core = {
        editor = "nvim";
      };
      pull.ff = "only";
      tag.gpgSign = true;
    };

    # git-delta
    # https://github.com/dandavison/delta
    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers";
        syntax-theme = "Monokai Extended Origin";
        delta = {
          navigate = true;
        };
      };
    };
  };
}
