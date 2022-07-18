{ ... }:

{
  programs.git = {
    enable = true;

    userName = "tars0x9752";
    userEmail = "46079709+tars0x9752@users.noreply.github.com";

    aliases = {
      # 直前のコミットメッセージと同じメッセージをベースにコミットする
      commit-same-msg = ''!git commit -F "$(git rev-parse --git-dir)/COMMIT_EDITMSG" --edit'';
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
