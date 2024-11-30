#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#Search inside files
alias fi='rg --column --line-number --no-heading --color=always . | fzf --ansi --delimiter : --preview "bat --style=numbers --color=always --highlight-line {2} {1}" --preview-window=right:60% | awk -F: "{print \$1 \":\" \$2}" | xargs -r vim'

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

# http://stackoverflow.com/questions/15883416/adding-git-branch-on-the-bash-command-prompt
# git completion support
[ -f ~/git-prompt.sh ] && source ~/git-prompt.sh

# Use bash-completion, if available
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -f /usr/share/bash-completion/completions/git ] && . /usr/share/bash-completion/completions/git

# [scripts]
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# [aliases]
alias ll="ls -laH --group-directories-first"
alias ls='ls -hF --color=tty'
alias mkdir='mkdir -p'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias grep="grep --color=always"

# [exports]
export EDITOR=vim

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=90000
export HISTTIMEFORMAT=""
export HISTCONTROL=ignoreboth:erasedups
# append to bash_history if Terminal.app quits
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export PATH=$HOME/bin:$HOME/.cargo/bin:$PATH
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
fi
export TERM=screen-256color

# [functions]
gitdiffb() {
  if [ $# -ne 2 ]; then
    echo two branch names required
    return
  fi
  git log --graph \
  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
  --abbrev-commit --date=relative $1..$2
}

git_extras_setup() {
    git clone https://github.com/tj/git-extras.git ~/git-extras
    cd ~/git-extras
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
    make install PREFIX=$HOME
    rm -rf ~/git-extras
}

[ -z "$TMUX"  ] && { tmux -2 && exit;}

