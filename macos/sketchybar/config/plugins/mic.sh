#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

VOLUME=$(osascript -e 'input volume of (get volume settings)' 2>/dev/null)

if [[ ! "$VOLUME" =~ ^[0-9]+$ ]]; then
    ICON=󰍭
    ICON_COLOR=$GREY
    LABEL="--"
elif [ "$VOLUME" = "0" ]; then
    ICON=󰍭
    ICON_COLOR=$GREY
    LABEL="0%"
else
    ICON=󰍬
    ICON_COLOR=$MAGENTA
    LABEL="${VOLUME}%"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$ICON_COLOR" label="$LABEL"
