{ ... }:

with builtins;
let
  DEFAULT_BRANCH = "main";
  DEFAULT_BRANCH_OLD = "master";
  DEVELOP_BRANCH = "develop";
  DEVELOP_BRANCH_ABBREV = "dev";

  PROTECTED_BRANCHE_LIST = [ DEFAULT_BRANCH DEFAULT_BRANCH_OLD DEVELOP_BRANCH DEVELOP_BRANCH_ABBREV ];

  PROTECTED_BRANCHES_STR = concatStringsSep "|" PROTECTED_BRANCHE_LIST;
in
{
  # gh auth login　時 readonly のエラー出るけど問題なし
  # https://github.com/cli/cli/issues/4955
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
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
        syntax-theme = "base16";
        delta.navigate = true;
      };
    };
  };

  # 暫定 (TODO: 不要になったら消す)
  xdg.configFile."git/ignore".text = ''
    .direnv
  '';

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

    g:diff.origin-head() {
      git diff origin/HEAD..HEAD
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

    g:commit.fixup() {
      git commit --fixup "$1"
    }

    # fixup + commit message 変更(3行目以下に新たなメッセージを入力)
    g:commit.fixup.amend() {
      git commit --fixup=amend:"$1"
    }

    # message 編集のみ(3行目以下に新たなメッセージを入力)
    g:commit.fixup.reword() {
      git commit --fixup=reword:"$1"
    }

    # ------ push ------

    g:push() {
      git push "$@"
    }

    g:push.force() {
      git push --force-with-lease
    }

    g:push.origin.head() {
      git push --set-upstream origin HEAD
    }

    g:push.origin.head.force() {
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

    # ------ rebase ------

    g:rebase.continue() {
      git rebase --continue 
    }

    g:rebase.i() {
      git rebase --interactive "$@" --autosquash
    }

    g:rebase.i.origin-head() {
      git rebase --interactive --fork-point origin/HEAD --autosquash
    }

    g:rebase.i.origin-head.no-edit() {
      git -c sequence.editor=true rebase --interactive --fork-point origin/HEAD --autosquash
    }

    # ------ remote ------

    g:remote.list() {
      git remote --verbose
    }

    g:remote.set-head.origin.auto() {
      git remote set-head origin --auto
    }

    ${concatStringsSep "\n" (map (branchname: ''
    g:remote.set-head.origin.${branchname}() {
      git remote set-head origin ${branchname}
    }
    '') PROTECTED_BRANCHE_LIST)}

    g:remote.show.origin() {
      git remote show origin
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

    # ------ reset ------

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
      git branch -d $(git branch --merged | rg --invert-match "\*|${PROTECTED_BRANCHES_STR}")
    }

    # プロテクトされてないブランチを一括削除
    g:delete-non-protected-branch() {
      git branch -D $(git branch | rg --invert-match "\*|${PROTECTED_BRANCHES_STR}")
    }

    ${concatStringsSep "\n" (map (branchname: ''
    # 現在のブランチを ${branchname} に rebase する
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
      echo "run g:status.mini"
      g:status.mini
    }

    g@a() {
      echo "run g:add.all"
      g:add.all
    }

    g@c() {
      g:commit
    }

    g@p() {
      echo "run g:push.origin.head"
      g:push.origin.head
    }

    g@f() {
      echo "run g:fetch.prune"
      g:fetch.prune
    }

    ${concatStringsSep "\n" (map (branchname: ''
    g@${branchname}() {
      echo "run: g:fetch.prune"
      g:fetch.prune
      echo "run: g:switch ${branchname}"
      g:switch ${branchname}
      echo "run: g:pull.${branchname}"
      g:pull.${branchname}
    }
    '') PROTECTED_BRANCHE_LIST)}

    g@d() {
      echo "run g:diff"
      g:diff
    }

    g@ds() {
      echo "run g:diff.staged"
      g:diff.staged
    }

    g@pf() {
      echo "run g:push.origin.head.force"
      g:push.origin.head.force
    }

    g@pr.auto-squash() {
      echo "run g:rebase.i.origin-head.no-edit"
      g:rebase.i.origin-head.no-edit
    }

    g@pr.diff() {
      echo "run g:diff.origin-head"
      g:diff.origin-head
    }

    g@s() {
      echo "run g:switch $1"
      g:switch $1
    }

    g@sc() {
      echo "run g:switch.create $1"
      g:switch.create $1
    }

    g@r() {
      echo "run g:restore.all"
      g:restore.all
    }

    ${concatStringsSep "\n" (map (branchname: ''
    g@rb.${branchname}() {
      echo "run g:rebase-${branchname}"
      g:rebase-${branchname}
    }
    '') PROTECTED_BRANCHE_LIST)}

    g@un() {
      echo "run g:restore.unstage.all"
      g:restore.unstage.all
    }

    g@l() {
      echo "run g:log.pretty-oneline"
      g:log.pretty-oneline
    }

    g@z-del-merged() {
      echo "run g:delete-merged-branch"
      g:delete-merged-branch
    }

    g@z-del-nonpro() {
      echo "run g:delete-non-protected-branch"
      g:delete-non-protected-branch
    }
  '';
}
