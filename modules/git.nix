{ ... }:

let
  DEFAULT_BRANCH = "main";
  DEFAULT_BRANCH_OLD = "master";
  DEVELOP_BRANCH = "develop";
  DEVELOP_BRANCH_ABBREV = "dev";
in
let
  PROTECTED_BRANCHES = "${DEFAULT_BRANCH}|${DEFAULT_BRANCH_OLD}|${DEVELOP_BRANCH}|${DEVELOP_BRANCH_ABBREV}";
in
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
      init = { defaultBranch = DEFAULT_BRANCH; };
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

  # tab 補完が効くように
  xdg.configFile."bash/git-functions.bash".text = ''
    # -----------------
    # git functions for bash
    # 極力tab補完で入力できるようにする
    #
    # g: basic function
    # g@ commonly used function
    # -----------------

    # ------ add ------

    function g:add {
      git add "$@"
    }

    function g:add.all {
      git add --all
      git status --short --branch
    }

    function g:add.patch {
      git add --patch
    }

    # ------ branch ------

    function g:branch {
      git branch "$@"
    }

    function g:branch.verbose {
      git branch --verbose
      git remote --verbose
    }

    function g:branch.delete {
      git branch --delete "$1"
    }

    # ------ cd ------

    function g:cd.top {
      cd "$(git rev-parse --show-toplevel)"
    }

    # ------ diff ------

    function g:diff {
      git diff "$@"
    }

    function g:diff.staged {
      git diff --staged
    }

    function g:diff.prev {
      git diff HEAD^
    }

    function g:diff.peek-commit {
      local commithash="$1"
      git diff "$commithash"^.."$commithash"
    }

    # ------ fetch ------

    function g:fetch {
      git fetch "$@"
    }

    function g:fetch.prune {
      git fetch --prune
    }

    # ------ commit ------

    function g:commit {
      git commit --verbose "$@"
    }

    function g:commit.amend {
      git commit --amend
    }

    function g:commit.amend.noedit {
      git commit --amend --no-edit
    }

    # ------ push ------

    function g:push {
      git push "$@"
    }

    function g:push.force {
      git push --force-with-lease
    }

    function g:push.origin-head {
      git push origin HEAD
    }

    function g:push.origin-head.force {
      git push origin HEAD --force-with-lease
    }

    # ------ log ------

    function g:log {
      git log "$@"
    }

    function g:log.signature {
      git log --show-signature "$@"
    }

    function g:log.pretty-oneline {
      git log --pretty=format:'%C(yellow)%h %Creset%ad %Cred%an%Cgreen%d %Creset%s' --date=short
    }

    function g:log.last {
      git log -1 HEAD --stat
    }

    # ------ config ------

    function g:config.ls {
      git config --list --show-origin
    }

    # ------ restore ------

    function g:restore {
      git restore "$@"
    }

    function g:restore.all {
      git restore .
    }

    function g:restore.unstage {
      git restore --staged "$@"
    }

    function g:restore.unstage.all {
      git restore --staged .
    }

    function g:restore.source {
      local commithash=$1
      local filename=$2
      git restore --source "$commithash" "$filename"
    }

    function g:restore {
      git restore --source "$@"
    }

    # ------ switch ------

    function g:switch {
      git switch "$@"
    }

    function g:switch.create {
      git switch --create "$@"
    }

    # ------ status ------

    function g:status {
      git status "$@"
    }

    function g:status.mini {
      git status --short --branch
    }

    # ------ show ------

    function g:show {
      git show "$@"
    }

    function g:show.head {
      git show HEAD
    }

    # ------ stash ------

    function g:stash {
      git stash "$@"
    }

    function g:stash.push {
      git stash push "$@"
    }

    function g:stash.push.patch {
      git stash push --patch "$@"
    }

    function g:stash.push.patch.untracked {
      git stash push --patch --include-untracked
    }

    function g:stash.push.untracked {
      git stash push --include-untracked "$@"
    }

    #  untracked に加え ignored なものも含む
    function g:stash.push.all {
      git stash push --all
    }

    # staged なものを stash する
    function g:stash.push.staged {
      git stash push --staged
    }

    function g:stash.pop {
      git stash pop "$@"
    }

    # stash されたものの diff を見る
    function g:stash.show {
      git stash show "$@"
    }

    function g:stash.list {
      git stash list "$@"
    }

    # ------ misc ------

    # http://stackoverflow.com/questions/4822471/count-number-of-lines-in-a-git-repository
    function g:count-line {
      git ls-files | xargs wc -l
    }

    ## delete merged branch
    function g:delete-merged-branch {
      git fetch --prune
      git branch --merged | rg --invert-match "\*|${PROTECTED_BRANCHES}" | xargs git branch -d
    }

    # 現在のブランチに ${DEFAULT_BRANCH} を rebase する
    function g:rebase-${DEFAULT_BRANCH} {
      local currentbranch=$(git branch --show-current)
      if [[ "$currentbranch" == "${DEFAULT_BRANCH}" ]]; then
        echo "Invalid operation. you are in ${${DEFAULT_BRANCH}} branch."
        false
      else
        git fetch origin
        git rebase origin/${${DEFAULT_BRANCH}}
      fi
    }

    # 現在のブランチに ${DEFAULT_BRANCH_OLD} を rebase する
    function g:rebase-${DEFAULT_BRANCH_OLD} {
      local currentbranch=$(git branch --show-current)
      if [[ "$currentbranch" == "${DEFAULT_BRANCH_OLD}" ]]; then
        echo "Invalid operation. you are in ${${DEFAULT_BRANCH_OLD}} branch."
        false
      else
        git fetch origin
        git rebase origin/${${DEFAULT_BRANCH_OLD}}
      fi
    }

    # 現在のブランチに ${DEVELOP_BRANCH} を rebase する
    function g:rebase-${DEVELOP_BRANCH} {
      local currentbranch=$(git branch --show-current)
      if [[ "$currentbranch" == "${DEVELOP_BRANCH}" ]]; then
        echo "Invalid operation. you are in ${${DEVELOP_BRANCH}} branch."
        false
      else
        git fetch origin
        git rebase origin/${${DEVELOP_BRANCH}}
      fi
    }

    # 現在のブランチに ${DEVELOP_BRANCH_ABBREV} を rebase する
    function g:rebase-${DEVELOP_BRANCH_ABBREV} {
      local currentbranch=$(git branch --show-current)
      if [[ "$currentbranch" == "${DEVELOP_BRANCH_ABBREV}" ]]; then
        echo "Invalid operation. you are in ${${DEVELOP_BRANCH_ABBREV}} branch."
        false
      else
        git fetch origin
        git rebase origin/${${DEVELOP_BRANCH_ABBREV}}
      fi
    }

    # ------ handy fns ------

    function g {
      g:status.mini
    }

    function g@a {
      g:add.all
    }

    function g@c {
      g:commit
    }

    function g@p {
      g:push.origin-head
    }

    function g@d {
      g:diff
    }

    function g@ds {
      g:diff.staged
    }

    function g@s {
      g:switch $1
    }

    function g@sc {
      g:switch.create $1
    }

    function g@ra {
      g:restore.all
    }

    function g@un {
      g:restore.unstage.all
    }

    function g@l {
      g:log.pretty-oneline
    }

    function g@zdelete {
      g:delete-merged-branch
    }
  '';
}
