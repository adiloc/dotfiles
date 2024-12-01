# ---------------------------------------
# General Bash Configurations
# ---------------------------------------
export EDITOR=vim
export PATH=$HOME/bin:$HOME/.cargo/bin:$PATH
export TERM=screen-256color

# Shared aliases and exports
alias ll='ls -lah'
alias ls='ls --color=auto'
alias grep='grep --color=always'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias vf="vim \$(fzf)"
alias cdf="cd \$(find . -type d | fzf)"
alias fgrep="rg --line-number | fzf --ansi --preview 'rg --color=always -C {}'"
alias gco="git checkout \$(git branch | fzf)"
export EDITOR=vim
export PATH=$HOME/bin:$HOME/.cargo/bin:$PATH
export TERM=screen-256color
export HISTFILE=~/.shell_history
export HISTSIZE=90000
export HISTTIMEFORMAT=""
export HISTCONTROL=ignoreboth:erasedups

# Eternal history
shopt -s histappend
shopt -s cdspell
shopt -s nocaseglob

# fzf configuration
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -200'
  --preview-window=right:60%
  --bind=ctrl-s:toggle-sort
"
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Function to search and cd into a directory
cdf() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Function to find and kill processes using fzf
fkill() {
  local pid
  pid=$(ps -ef | fzf --multi | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "Killing process ID(s): $pid"
    echo "$pid" | xargs kill -9
  else
    echo "No process selected."
  fi
}

# Shell-specific configurations
if [[ -n "$ZSH_VERSION" ]]; then
  # Zsh-specific settings
  autoload -Uz compinit
  compinit
  setopt inc_append_history
  setopt share_history
  PROMPT='%n@%m %1~ %# '
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  source <(fzf --zsh)
elif [[ -n "$BASH_VERSION" ]]; then
  # Bash-specific settings
  PS1='[\u@\h \W]\$ '
  [ -f ~/git-prompt.sh ] && source ~/git-prompt.sh
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
fi


# Enhanced directory navigation using fzf
# CTRL-T: File searching
bindkey '^T' fzf-file-widget
# CTRL-R: Command history search
bindkey '^R' fzf-history-widget
# ALT-C: Directory search
bindkey '\ec' fzf-cd-widget

# Function to search and cd into a directory using fzf
cdf() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Alias for searching inside files with fzf
alias fi='rg --column --line-number --no-heading --color=always . | \
fzf --ansi --delimiter : --preview "bat --style=numbers --color=always --highlight-line {2} {1}" \
--preview-window=right:60% | awk -F: "{print \$1 \":\" \$2}" | xargs -r vim'

# fzf configuration for ignoring certain directories (like .git and node_modules)
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'

# fzf visual options
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -200'
  --preview-window=right:60%
  --bind=ctrl-s:toggle-sort
"
# Git-specific Configurations
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_DESCRIBE_STYLE=branch

# Colorful and informative Git prompt
PS1='[\u@\h \W$(__git_ps1 " (%s)")] \$ '

# Load Git completion and prompt (install if missing)
if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
elif [ -f ~/git-prompt.sh ]; then
  source ~/git-prompt.sh
fi

# ---------------------------------------
# Aliases for Git Workflow
# ---------------------------------------
# Common shortcuts
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

# Show branches sorted by the latest commit
alias gb="git branch --sort=-committerdate"

# Interactive rebase
alias gri="git rebase -i"

# Delete a branch (local + remote)
delete_branch() {
  local branch=${1:?Usage: delete_branch <branch>}
  git branch -d "$branch" && git push origin --delete "$branch"
}
alias gbdel="delete_branch"

# Cherry-pick commits interactively
alias gcp="git cherry-pick"

# Restore file to the last commit
alias gr="git restore"

# Stash management
alias gss="git stash save"
alias gsp="git stash pop"
alias gsl="git stash list"

# Reset workflows
alias ghard="git reset --hard"
alias gsoft="git reset --soft"
alias gmixed="git reset --mixed"

# ---------------------------------------
# Git Utilities
# ---------------------------------------

# fzf: Checkout a branch interactively
gco_fzf() {
  git branch --sort=-committerdate | fzf --preview="git log --oneline --graph --decorate --color=always {}" | xargs git checkout
}

# fzf: Interactive stash selection
gstash_fzf() {
  git stash list | fzf --preview="git stash show -p {1}" | awk '{print $1}' | xargs -r git stash apply
}

# View Git log with fzf
glog_fzf() {
  git log --oneline --graph --decorate --color=always | fzf --preview="echo {}"
}

alias gcofz="gco_fzf"
alias gstashfz="gstash_fzf"
alias glogfz="glog_fzf"

# ---------------------------------------
# Advanced Git Functions
# ---------------------------------------

# Compare two branches
git_compare() {
  local branch1=${1:?Usage: git_compare <branch1> <branch2>}
  local branch2=${2:?Usage: git_compare <branch1> <branch2>}
  git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit $branch1..$branch2
}

# Clone a repository with a specific branch
git_clone_branch() {
  local repo=${1:?Usage: git_clone_branch <repo> <branch>}
  local branch=${2:-main}
  git clone --branch "$branch" "$repo"
}

# ---------------------------------------
# Additional Productivity Tools
# ---------------------------------------

# Ripgrep and fzf for searching inside a repository
alias gsearch="rg --column --line-number --no-heading --color=always | fzf --ansi --preview 'bat --style=numbers --color=always {1} --highlight-line {2}'"

# Search and switch branches interactively
alias gswitch="git branch | fzf | xargs git checkout"

# Clean up merged branches (local)
alias gclean="git branch --merged | grep -v '\\*' | xargs -r git branch -d"

# Show large files in the repository
alias glarge="git rev-list --objects --all | git cat-file --batch-check | sort -k3 -rn | head"

# ---------------------------------------
# Helpful Utilities
# ---------------------------------------
# Better diff with side-by-side view
alias gdiff="git diff --color-words"

# Check current Git configuration
alias gconfig="git config --list --show-origin"

# Unstage files
alias gunstage="git restore --staged"

# List Git aliases
alias galias="git config --get-regexp '^alias\.'"

# ---------------------------------------
# History and Safety
# ---------------------------------------
# Enable history
HISTFILE=~/.bash_history
HISTSIZE=100000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Confirm dangerous actions
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'


