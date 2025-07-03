#!/bin/bash

# Find Telegram window ID
win_id=$(hyprctl clients -j | jq -r '.[] | select(.class == "org.telegram.desktop") | .address' | head -n1)

# Focus Telegram if found
if [[ -n "$win_id" ]]; then
    hyprctl dispatch focuswindow address:$win_id
fi
