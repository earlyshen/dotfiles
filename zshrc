ZSH=$HOME/.oh-my-zsh
ZSH_THEME="blinks"

plugins=(git git-extras github brew brew-cast gem jump zsh_reload)

export PATH="/usr/local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# for Homebrew installed rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
