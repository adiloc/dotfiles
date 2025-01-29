#!/bin/bash

bookmark="$(xclip -o)"
file="$HOME/.vimwiki/bookmarks.md"

if grep -Fxq "$bookmark" "$file"; then
    notify-send "Already bookmarked!"
else
    echo "$bookmark" >> "$file"
    notify-send "Bookmark added!" "$bookmark is now saved to the file."
fi
