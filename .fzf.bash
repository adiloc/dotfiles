# Setup fzf
# ---------
if [[ ! "$PATH" == */home/loc/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/loc/.fzf/bin"
fi

eval "$(fzf --bash)"
