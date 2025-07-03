#!/bin/bash
# Log for debugging
echo "Received: Desktop Entry: $DUNST_DESKTOP_ENTRY, Summary: $DUNST_SUMMARY, Body: $DUNST_BODY, Urgency: $DUNST_URGENCY, ID: $DUNST_ID, Icon: $DUNST_ICON_PATH" >> ~/telegram_log.txt

# Verify notification is from Telegram
if [ "$DUNST_DESKTOP_ENTRY" = "org.telegram.desktop" ]; then
    # Dismiss the original notification
    dunstctl close $DUNST_ID

    # Use DUNST_ICON_PATH if available, else fallback to Telegram's system icon
    icon="$DUNST_ICON_PATH"
    [ -z "$icon" ] || [ ! -f "$icon" ] && icon="telegram"

    # Send a new notification with the same content and a clickable action
    response=$(dunstify -a "Telegram Desktop" -h string:desktop-entry:telegram-desktop -u "$DUNST_URGENCY" -i "$DUNCT_ICON_PATH" -A "switch,Switch to Telegram" "$DUNST_SUMMARY" "$DUNST_BODY")

    # Check if the action was clicked
    if [ "$response" = "switch" ]; then
        ~/.config/dunst/telegram_focus.sh
    fi
fi
