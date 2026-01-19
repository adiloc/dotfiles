#!/bin/bash

# File to store last brightness
STATE_FILE="$HOME/.last_brightness"

DEVICE="intel_backlight"

# Get current brightness
current=$(brightnessctl -d "$DEVICE" get)

if [[ "$current" -eq 0 ]]; then
    # Restore previous brightness
    if [[ -f "$STATE_FILE" ]]; then
        last=$(<"$STATE_FILE")
    else
        # Default to 50% if no previous state saved
        max=$(brightnessctl -d "$DEVICE" max)
        last=$(( max / 2 ))
    fi
    brightnessctl -d "$DEVICE" set "$last"
else
    # Save current brightness and turn off
    echo "$current" > "$STATE_FILE"
    brightnessctl -d "$DEVICE" set 0
fi

