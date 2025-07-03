#!/bin/bash

# Ensure we have access to user's environment (optional in user session)
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Get default sink info from wpctl
status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Parse volume and mute status
volume_float=$(echo "$status" | grep -oP '\d+\.\d+')
volume=$(printf "%.0f" "$(echo "$volume_float * 100" | bc -l)")

muted=$(echo "$status" | grep -q '\[MUTED\]' && echo "yes" || echo "no")

Cap volume at 100%
if [ "$volume" -gt 100 ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0
    volume=100
fi

# Create fixed-width bar (28 characters)
bar_length=30

filled_length=$(($volume * $bar_length / 100))

if [ "$muted" = "yes" ]; then
    bar=$(printf '░%.0s' $(seq 1 $bar_length))
    message="Volume: Muted"
else
    if [ "$volume" -eq 100 ]; then
        message="Volume ${volume}%"
        bar=$(printf '█%.0s' $(seq 1 $bar_length))
    elif [ "$volume" -eq 0 ]; then
        message="Volume ${volume}%"
        bar=$(printf '░%.0s' $(seq 1 $bar_length))
    else
        empty_length=$((bar_length - filled_length))
        bar="$(printf '█%.0s' $(seq 1 $filled_length))$(printf '░%.0s' $(seq 1 $empty_length))"
        message="Volume ${volume}%"
    fi
fi

# Send notification
notify-send -r 9992 -t 500 -u low -h string:x-canonical-private-synchronous:volume \
    "$message" "$bar"
