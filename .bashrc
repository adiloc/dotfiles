# ---------------------------------------
# General Bash Configurations
# ---------------------------------------
export EDITOR=vim
export PATH=$HOME/bin:$HOME/.cargo/bin:$PATH
export TERM=screen-256color
export HISTFILE=~/.bash_history
export HISTSIZE=100000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT=""
export PATH=~/.npm-global/bin:$PATH
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=dark
export QT_QPA_PLATFORMTHEME=gtk2

set -o vi

shopt -s histappend       # Append history instead of overwriting
shopt -s cdspell          # Correct minor spelling errors in `cd`
shopt -s nocaseglob       # Case-insensitive filename matching

# ---------------------------------------
# Aliases and Shortcuts
# ---------------------------------------
alias ll='ls -lah'
alias ls='ls --color=auto'
alias grep='grep --color=always'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias vf="vim \$(fzf)"
alias fgrep="rg --line-number | fzf --ansi --preview 'rg --color=always -C {}'"
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
eval $(thefuck --alias f)

# ---------------------------------------
# fzf Configuration
# ---------------------------------------
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -200'
  --preview-window=right:60%
  --bind=ctrl-s:toggle-sort
"
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'

# Load fzf if installed
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Function to search and `cd` into a directory
function cdf() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Function to find and kill processes using fzf
function fkill() {
  local pid
  pid=$(ps -ef | fzf --multi | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "Killing process ID(s): $pid"
    echo "$pid" | xargs kill -9
  else
    echo "No process selected."
  fi
}

# ---------------------------------------
# Git-Specific Configurations
# ---------------------------------------
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_DESCRIBE_STYLE=branch

# Colorful and informative Git prompt
PS1='\[\033[1;31m\][\[\033[1;33m\]\u\[\033[1;32m\]@\[\033[1;34m\]\h \[\033[1;35m\]\w\[\033[1;31m\]]\[\033[0m\]$(__git_ps1 " (%s)") \$ '

# Load Git completion and prompt (install if missing)
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  source /usr/share/git/completion/git-prompt.sh
elif [ -f /etc/bash_completion.d/git-prompt ]; then
  source /etc/bash_completion.d/git-prompt
elif [ -f ~/git-prompt.sh ]; then
  source ~/git-prompt.sh
fi

# ---------------------------------------
# Git Workflow Aliases and Functions
# ---------------------------------------
# Common Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -v"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate --all"
alias gcm="git commit -m"
alias gcb="git checkout -b"
alias gb="git branch --sort=-committerdate"
alias gri="git rebase -i"
alias gr="git restore"
alias gss="git stash save"
alias gsp="git stash pop"
alias gsl="git stash list"
alias ghard="git reset --hard"
alias gsoft="git reset --soft"
alias gmixed="git reset --mixed"

# Interactive Git workflows using fzf
alias gcofz="git branch --sort=-committerdate | fzf | xargs git checkout"
alias gstashfz="git stash list | fzf --preview='git stash show -p {}' | awk '{print \$1}' | xargs git stash apply"
alias glogfz="git log --oneline --graph --decorate --color=always | fzf --preview='echo {}'"

# Enhanced Git utilities
alias gclean="git branch --merged | grep -v '\\*' | xargs -r git branch -d"
alias glarge="git rev-list --objects --all | git cat-file --batch-check | sort -k3 -rn | head"

# ---------------------------------------
# Productivity Utilities
# ---------------------------------------
# Added an alias 'fif' for searching inside files using ripgrep (rg) combined with fzf for interactive selection.
alias fif='rg --column --line-number --no-heading --color=always . | \
    fzf --ansi --delimiter : --preview "bat --style=numbers --color=always --highlight-line {2} {1}" \
    --preview-window=right:60% | awk -F: "{print \$1 \":\" \$2}" | sed "s/:3$//" | xargs -o -r vim'

# ---------------------------------------
# Final Configurations
# ---------------------------------------

