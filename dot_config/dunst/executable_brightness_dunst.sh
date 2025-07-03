#!/bin/bash

# Ensure we have access to user's environment
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# Get current brightness using brightnessctl
brightness=$(brightnessctl info | grep -oE '[0-9]+%' | head -n1 | tr -d '%')

# Create fixed-width bar (shorter length to prevent wrapping)
bar_length=30  # Reduced from 35 to 28

filled_length=$(($brightness * $bar_length / 100))

# Special case for 100% brightness
if [ "$brightness" -eq 100 ]; then
    bar=$(printf '█%.0s' $(seq 1 $bar_length))
else
    empty_length=$((bar_length - filled_length))
    bar="$(printf '█%.0s' $(seq 1 $filled_length))$(printf '░%.0s' $(seq 1 $empty_length))"
fi

# Send notification
/usr/bin/notify-send -r 9991 -t 500 -u low -h string:x-canonical-private-synchronous:brightness \
    "Brightness ${brightness}%" "$bar"
