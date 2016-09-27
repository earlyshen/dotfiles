ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
DEFAULT_USER="erh-li.shen"

plugins=(git git-extras brew brew-cask gem jump zsh_reload last-working-dir)

export PATH="/usr/local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

func rmAppCode (){
  rm -rf ~/Library/Caches/appCode31/*
}

func rmXcode () {
  rm -rf ~/Library/Developer/Xcode/DerivedData/*
}

# load the workday files
files=(~/.workday/source/*.sh)
for file in ${files}; do
  source $file
done

func gitRemoteBranch() {
  git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)
}

func gitClean(){

  echo "=== Cleaning Remote Branch Caches ==="
  git remote prune origin

  # echo "=== Cleaning Local Branches ========="
  # except_branches=('"\*"' 'master' 'develop' 'rc')
  # command="git branch --merged"
  # for branch in $except_branches; do
  #   command="$command | grep -v $branch"
  # done
  # command="$command | xargs -n 1 git branch -d"
  # eval $command

  echo "=== Cleaning Local Branches With Empty Merges ==="
  command="git branch"
  for branch in $except_branches; do
      command="$command | grep -v $branch"
  done
  localBranches=(`eval $command`)
  for branch in $localBranches; do
      mergeBase=`git merge-base HEAD $branch`
      git merge-tree "$mergeBase" HEAD "$branch" | read
      if [ $? -ne 0 ]; then
          git branch -D $branch
      fi
  done

  echo "=== Remaining Branches =============="
  git branch
}

func gitUpdatebases() {
    git fetch origin
    basis_branches=('master' 'develop' 'rc')
    for branch in $basis_branches; do
        # verify it exists
        git show-ref --verify --quiet refs/heads/"$branch"
        if [ $? -ne 0 ]; then
            continue
        fi

        # verify it can be fast forwarded
        git merge-base --is-ancestor "$branch" origin/"$branch"
        if [ $? -ne 0 ]; then
            echo "$branch cannot be fast-forwarded to origin/$branch, you'll need to manually update your branch"
            continue
        fi

        # Change the branch ref to point to the new one
        echo "Updating $branch to origin/$branch"
        git update-ref refs/heads/"$branch" origin/"$branch"
    done
}

alias tsint="devPassword -e tsinternal"
alias tsprod="devPassword -e tsprod"

alias bootstrap="carthage bootstrap --platform ios --no-build"
alias build="carthage build --platform ios"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
