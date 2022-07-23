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
  local $commithash=$1
  git diff $commithash^..$commithash
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
  local PROTECTED_BRANCHES="main|master|develop|dev"
  git fetch --prune
  git branch --merged | rg --invert-match "\*|${PROTECTED_BRANCHES}" | xargs git branch -d
}

# 現在のブランチに main を rebaseする
function g:rebase-main {
  local currentbranch=$(git branch --show-current)
  if [[ "$currentbranch" == "main" ]]; then
    echo "Invalid operation. you are in main branch."
    false
  else
    git fetch origin
    git rebase origin/main
  fi
}

function g:rebase-master {
  local currentbranch=$(git branch --show-current)
  if [[ "$currentbranch" == "master" ]]; then
    echo "Invalid operation. you are in master branch."
    false
  else
    git fetch origin
    git rebase origin/main
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
