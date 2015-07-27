ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
DEFAULT_USER="erh-li.shen"

plugins=(git git-extras github brew brew-cask gem jump zsh_reload)

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

source ~/.workday/clear_build_caches.sh

func gitRemoteBranch() {
  git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)
}

func gitClean(){

  echo "=== Cleaning Remote Branch Caches ==="
  git remote prune origin

  echo "=== Cleaning Local Branches ========="
  except_branches=('"\*"' 'master' 'develop' 'rc')
  command="git branch --merged"
  for branch in $except_branches; do
    command="$command | grep -v $branch"
  done
  command="$command | xargs -n 1 git branch -d"
  eval $command

  echo "=== Remaining Branches =============="
  git branch
}
