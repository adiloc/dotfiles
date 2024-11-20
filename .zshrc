# Start fzf in interactive mode for reverse-i-search
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Keybindings for fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enhanced directory navigation using fzf
# CTRL-T: File searching
bindkey '^T' fzf-file-widget
# CTRL-R: Command history search
bindkey '^R' fzf-history-widget
# ALT-C: Directory search
bindkey '\ec' fzf-cd-widget

# Define the function
fzf_search_files() {
    local file
		    file=$(rg --files | fzf --preview 'cat {} | head -100')
				    if [[ -n "$file" ]]; then
						        vim "$file"
										    fi
												}

												# Bind Ctrl+f to run the function in Zsh
												function _fzf_search_files { fzf_search_files; }
												zle -N _fzf_search_files
												bindkey '^f' _fzf_search_files
												
# Command to search for files with fzf and open in vim
ff() {
  vim $(fzf)
}

# Command to change directory using fzf
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# Search files in the current directory and open with vim
alias vf="vim \$(fzf)"

# Search and change directory with fzf
alias cdf="cd \$(find . -type d | fzf)"

# Grep through the current directory and display matches
alias fgrep="rg --line-number | fzf --ansi --preview 'rg --color=always -C {}'"

# Search Git branches and switch
alias gco="git checkout \$(git branch | fzf)"

# Add preview for file contents in fzf results
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -200'
  --preview-window=right:60%
  --bind=ctrl-s:toggle-sort
"
# Function to find and kill processes using fzf
fkill() {
  # List processes, use fzf to select, then kill the selected process
  local pid
  pid=$(ps -ef | fzf --multi | awk '{print $2}')
  
  if [[ -n "$pid" ]]; then
    echo "Killing process ID(s): $pid"
    echo "$pid" | xargs kill -9
  else
    echo "No process selected."
  fi
}
#Ignore fzf directories
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*" -not -path "*/node_modules/*"'



# Enable history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt inc_append_history  # Save every command as it's typed
setopt share_history  # Share history across all sessions

# Prompt
PROMPT='%n@%m %1~ %# '

# Enable completion
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Aliases
alias ll='ls -lah'
alias ..='cd ..'

# Set up fzf key bidings and fuzzy
source <(fzf --zsh)
