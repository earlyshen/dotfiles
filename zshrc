# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/erh-li.shen/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.dotfiles/oh-my-zsh/custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras brew cask gem jump zsh_reload last-working-dir xcode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


DEFAULT_USER="erh-li.shen"

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

func switchXcode(){
  oldXcode=/Applications/Xcode_8.app
  newXcode=/Applications/Xcode.app

  current=`xcode-select -p`
  if [[ $current =~ ^$oldXcode ]]; then
    current="$newXcode"
  else
    current="$oldXcode"
  fi
  sudo xcode-select -s $current
  echo "Switch to $current"
}

alias tsint="devPassword -e tsinternal"
alias tsprod="devPassword -e tsprod"

alias bootstrap="carthage bootstrap --platform ios --cache-builds"
alias build="carthage build --platform ios --cache-builds"

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
