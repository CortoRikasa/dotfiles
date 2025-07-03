#!/usr/bin/env bash

# Import Current Theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Get player status and metadata
status="$(playerctl status 2>/dev/null)"
if [[ -z "$status" ]]; then
    prompt='Offline'
    mesg="Player is Offline"
else
    artist="$(playerctl metadata artist 2>/dev/null)"
    title="$(playerctl metadata title 2>/dev/null)"
    playing_symbol="▶"
    paused_symbol="⏸"
    prompt="$artist"
    mesg="$title :: $status"
fi

# Determine layout
# if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
#     list_col='1'
#     list_row='6'
# elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
#     list_col='6'
#     list_row='1'
# fi
if [[ ( "$theme" == *'type-1'* ) || ( "$theme" == *'type-3'* ) || ( "$theme" == *'type-5'* ) ]]; then
    list_col='1'
    list_row='3'
elif [[ ( "$theme" == *'type-2'* ) || ( "$theme" == *'type-4'* ) ]]; then
    list_col='3'
    list_row='1'
fi

# Options setup
layout=$(grep 'USE_ICON' "$theme" | cut -d'=' -f2)
if [[ "$layout" == 'NO' ]]; then
    if [[ "$status" == "Playing" ]]; then
        option_1=" Pause"
    else
        option_1=" Play"
    fi
    # option_2=" Stop"
    option_3=" Previous"
    option_4=" Next"
    # option_5=" Repeat"
    # option_6=" Shuffle"
else
    if [[ "$status" == "Playing" ]]; then
        option_1=""
    else
        option_1=""
    fi
    # option_2=""
    option_3=""
    option_4=""
    # option_5=""
    # option_6=""
fi

# Toggle Actions (repeat & shuffle)
active=''
urgent=''

# repeat_status=$(playerctl loop status 2>/dev/null)
# shuffle_status=$(playerctl shuffle 2>/dev/null)

# # Repeat toggle handling
# if [[ "$repeat_status" == "Playlist" || "$repeat_status" == "Track" ]]; then
#     active="-a 4"
# elif [[ "$repeat_status" == "None" ]]; then
#     urgent="-u 4"
# else
#     option_5=" Parsing Error"
# fi

# # Shuffle toggle handling
# if [[ "$shuffle_status" == "On" ]]; then
#     if [[ -n "$active" ]]; then active+=",5"; else active="-a 5"; fi
# elif [[ "$shuffle_status" == "Off" ]]; then
#     if [[ -n "$urgent" ]]; then urgent+=",5"; else urgent="-u 5"; fi
# else
#     option_6=" Parsing Error"
# fi

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
         -theme-str 'textbox-prompt-colon {str: "";}' \
         -dmenu \
         -p "$prompt" \
         -mesg "$mesg" \
         ${active} ${urgent} \
         -markup-rows \
         -theme ${theme}
}

# Pass variables to rofi dmenu
# run_rofi() {
#     echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
# }
run_rofi() {
    echo -e "$option_1\n$option_3\n$option_4" | rofi_cmd
}

# Execute Command
run_cmd() {
    case "$1" in
        --opt1)
            if [[ "$status" == "Playing" ]]; then
                playerctl pause
                notify-send -u low -t 1000 " Paused: $artist - $title"
            else
                playerctl play
                notify-send -u low -t 1000 " Playing: $artist - $title"
            fi
            ;;
        # --opt2)
        #     playerctl stop
        #     ;;
        --opt3)
            playerctl -p firefox.instance_1_22 previous
            notify-send -u low -t 1000 " Previous track"
            ;;
        --opt4)
            playerctl -p firefox.instance_1_22 next
            notify-send -u low -t 1000 " Next track"
            ;;
        # --opt5)
        #     # Toggle repeat modes: None -> Playlist -> Track
        #     if [[ "$repeat_status" == "None" ]]; then
        #         playerctl loop playlist
        #     elif [[ "$repeat_status" == "Playlist" ]]; then
        #         playerctl loop track
        #     else
        #         playerctl loop none
        #     fi
        #     ;;
        # --opt6)
        #     # Toggle shuffle On/Off
        #     if [[ "$shuffle_status" == "On" ]]; then
        #         playerctl shuffle off
        #     else
        #         playerctl shuffle on
        #     fi
        #     ;;
    esac
}

# Actions
chosen="$(run_rofi)"
case "${chosen}" in
    $option_1) run_cmd --opt1 ;;
    # $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    # $option_5) run_cmd --opt5 ;;
    # $option_6) run_cmd --opt6 ;;
esac
