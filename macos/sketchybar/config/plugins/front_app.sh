#!/usr/bin/env zsh

source "$CONFIG_DIR/colors.sh"

STATE=$(aerospace list-windows --focused --format "%{window-is-fullscreen} %{window-parent-container-layout}" 2>/dev/null)
FULLSCREEN=${STATE%% *}
LAYOUT=${STATE##* }

SUFFIX=""
if [ "$FULLSCREEN" = "true" ]; then
    SUFFIX=" (fullscreen)"
elif [ "$LAYOUT" = "floating" ]; then
    SUFFIX=" (floating)"
fi

INFO=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')
sketchybar --set "$NAME" label="$INFO$SUFFIX"
