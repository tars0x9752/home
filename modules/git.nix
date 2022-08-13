{ ... }:

with builtins;
let
  DEFAULT_BRANCH = "main";
  DEFAULT_BRANCH_OLD = "master";
  DEVELOP_BRANCH = "develop";
  DEVELOP_BRANCH_ABBREV = "dev";
in
let
  PROTECTED_BRANCHE_LIST = [ DEFAULT_BRANCH DEFAULT_BRANCH_OLD DEVELOP_BRANCH DEVELOP_BRANCH_ABBREV ];
in
let
  PROTECTED_BRANCHES = concatStringsSep "|" [ DEFAULT_BRANCH DEFAULT_BRANCH_OLD DEVELOP_BRANCH DEVELOP_BRANCH_ABBREV ];
in
{
  # gh auth login　時 readonly のエラー出るけど問題なし
  # https://github.com/cli/cli/issues/4955
  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  programs.git = {
    enable = true;

    userName = "tars0x9752";
    userEmail = "46079709+tars0x9752@users.noreply.github.com";

    includes = [{ path = "~/.config/git/localconf"; }];

    signing = {
      key = "7E48DB4B7AADB252";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = DEFAULT_BRANCH;
      branch.sort = "-committerdate";
      core.editor = "nvim";
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
        delta.navigate = true;
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

    g:add() {
      git add "$@"
    }

    g:add.all() {
      git add --all
      git status --short --branch
    }

    g:add.patch() {
      git add --patch
    }

    # ------ branch ------

    g:branch() {
      git branch "$@"
    }

    g:branch.verbose() {
      git branch --verbose
      git remote --verbose
    }

    g:branch.delete() {
      git branch --delete "$1"
    }

    # ------ cd ------

    g:cd.top() {
      cd "$(git rev-parse --show-toplevel)"
    }

    # ------ diff ------

    g:diff() {
      git diff "$@"
    }

    g:diff.staged() {
      git diff --staged
    }

    g:diff.prev() {
      git diff HEAD^
    }

    g:diff.peek-commit() {
      local commithash="$1"
      git diff "$commithash"^.."$commithash"
    }

    # ------ fetch ------

    g:fetch() {
      git fetch "$@"
    }

    g:fetch.prune() {
      git fetch --prune
    }

    # ------ commit ------

    g:commit() {
      git commit --verbose "$@"
    }

    g:commit.amend() {
      git commit --amend
    }

    g:commit.amend.noedit() {
      git commit --amend --no-edit
    }

    # ------ push ------

    g:push() {
      git push "$@"
    }

    g:push.force() {
      git push --force-with-lease
    }

    g:push.origin-head() {
      git push --set-upstream origin HEAD
    }

    g:push.origin-head.force() {
      git push origin HEAD --force-with-lease
    }

    # ------ pull ------

    g:pull() {
      git pull "$@"
    }

    ${concatStringsSep "\n" (map (branchname: ''
    g:pull.${branchname}() {
      git pull origin ${branchname}
    }
    '') PROTECTED_BRANCHE_LIST)}

    # ------ log ------

    g:log() {
      git log "$@"
    }

    g:log.signature() {
      git log --show-signature "$@"
    }

    g:log.pretty-oneline() {
      git log --pretty=format:'%C(yellow)%h %Creset%ad %Cred%an%Cgreen%d %Creset%s' --date=short
    }

    g:log.last() {
      git log -1 HEAD --stat
    }

    # ------ config ------

    g:config.ls() {
      git config --list --show-origin
    }

    # ------ restore ------

    g:restore() {
      git restore "$@"
    }

    g:restore.all() {
      git restore .
    }

    g:restore.unstage() {
      git restore --staged "$@"
    }

    g:restore.unstage.all() {
      git restore --staged .
    }

    g:restore.source() {
      local commithash=$1
      local filename=$2
      git restore --source "$commithash" "$filename"
    }

    g:restore() {
      git restore --source "$@"
    }

    # ------ RESET ------

    g:reset@1() {
      git reset --mixed HEAD~1
    }

    g:reset.soft@1() {
      git reset --soft HEAD~1
      g:status.mini
    }

    g:reset.hard@1() {
      git reset --hard HEAD~1
    }

    # ------ switch ------

    g:switch() {
      git switch "$@"
    }

    g:switch.create() {
      git switch --create "$@"
    }

    # ------ status ------

    g:status() {
      git status "$@"
    }

    g:status.mini() {
      git status --short --branch
    }

    # ------ show ------

    g:show() {
      git show "$@"
    }

    g:show.head() {
      git show HEAD
    }

    # ------ stash ------

    g:stash() {
      git stash "$@"
    }

    g:stash.push() {
      git stash push "$@"
    }

    g:stash.push.patch() {
      git stash push --patch "$@"
    }

    g:stash.push.patch.untracked() {
      git stash push --patch --include-untracked
    }

    g:stash.push.untracked() {
      git stash push --include-untracked "$@"
    }

    #  untracked に加え ignored なものも含む
    g:stash.push.all() {
      git stash push --all
    }

    # staged なものを stash する
    g:stash.push.staged() {
      git stash push --staged
    }

    g:stash.pop() {
      git stash pop "$@"
    }

    # stash されたものの diff を見る
    g:stash.show() {
      git stash show "$@"
    }

    g:stash.list() {
      git stash list "$@"
    }

    # ------ misc ------

    # http://stackoverflow.com/questions/4822471/count-number-of-lines-in-a-git-repository
    g:count-line() {
      git ls-files | xargs wc -l
    }

    # マージ済みブランチを削除
    # 注: squash マージされたものは git branch --merged で表示されないのでこれでは消せないことに注意
    g:delete-merged-branch() {
      git fetch --prune
      git branch -d $(git branch --merged | rg --invert-match "\*|${PROTECTED_BRANCHES}")
    }

    # プロテクトされてないブランチを一括削除
    g:delete-non-protected-branch() {
      git branch -D $(git branch | rg --invert-match "\*|${PROTECTED_BRANCHES}")
    }

    ${concatStringsSep "\n" (map (branchname: ''
    # 現在のブランチに ${branchname} を rebase する
    g:rebase-${branchname}() {
      local currentbranch=$(git branch --show-current)
      if [[ "$currentbranch" == "${branchname}" ]]; then
        echo "Invalid operation. you are in ${branchname} branch."
        false
      else
        git fetch origin
        git rebase origin/${branchname}
      fi
    }
    '') PROTECTED_BRANCHE_LIST)}

    # ------ handy fns ------

    g() {
      g:status.mini
    }

    g@a() {
      g:add.all
    }

    g@c() {
      g:commit
    }

    g@p() {
      g:push.origin-head
    }

    g@f() {
      g:fetch.prune
    }

    ${concatStringsSep "\n" (map (branchname: ''
    g@${branchname}() {
      g:fetch.prune
      g:switch ${branchname}
      g:pull.${branchname}
    }
    '') PROTECTED_BRANCHE_LIST)}

    g@d() {
      g:diff
    }

    g@ds() {
      g:diff.staged
    }

    g@s() {
      g:switch $1
    }

    g@sc() {
      g:switch.create $1
    }

    g@ra() {
      g:restore.all
    }

    g@un() {
      g:restore.unstage.all
    }

    g@l() {
      g:log.pretty-oneline
    }

    g@z-del-merged() {
      g:delete-merged-branch
    }

    g@z-del-nonpro() {
      g:delete-non-protected-branch
    }
  '';
}
