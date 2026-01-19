#!/bin/bash
# File: ~/bin/runappimage.sh
APPIMAGE_DIR="$HOME/applications/AppImages"

# List AppImages (strip path and .AppImage)
CHOICE=$(ls "$APPIMAGE_DIR" | sed 's/\.AppImage$//' | dmenu -i -p "Run AppImage:")

# If user selected something, run it
if [ -n "$CHOICE" ]; then
    "$APPIMAGE_DIR/$CHOICE.AppImage" &
fi

