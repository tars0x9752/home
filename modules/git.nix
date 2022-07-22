{ ... }:

{
  programs.git = {
    enable = true;

    userName = "tars0x9752";
    userEmail = "46079709+tars0x9752@users.noreply.github.com";

    aliases = {
      # add
      a = "add";
      a-p = "add -p";
      a-a = "!git add --all && git status --short --branch";

      # branch
      b = "branch --verbose";
      b-r = "!git branch --verbose && git remote --verbose";

      # commit
      c = "commit --verbose";
      c-ame = "commit --amend";
      c-ameno = "commit --amend --no-edit";

      # diff
      d = "diff";
      d-stg = "diff --staged";
      d-prev = "diff HEAD^";
      d-com = ''diff "$1"^.."$1"'';

      # fetch
      f = "fetch --prune";

      # cd
      top = ''!cd "$(git rev-parse --show-toplevel)"'';
      root = ''!cd "$(git rev-parse --show-toplevel)"'';

      # count-number-of-lines-in-a-git-repository
      count-line = "!git ls-files | xargs wc -l";

      # push
      p = "push";
      p-f = "push --force-with-lease";

      # log
      l = "log";
      l-oneline = "log --pretty=format:'%C(yellow)%h %Creset%ad %Cred%an%Cgreen%d %Creset%s' --date=short";
      l-last = "log -1 HEAD --stat";
      l-s = "log --show-signature";

      # conf
      conf-ls = "config --list --show-origin";

      # restore
      r = "restore";

      # switch
      s = "switch";
      s-c = "switch --create";

      # status
      st = "status";
      st-s = "status --short --branch";
    };

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
