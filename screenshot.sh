#!/bin/bash

write_to=$(echo -e 'file\nclipboard' | rofi -dmenu -p 'write screenshot to:' -theme ~/.config/rofi/launchers/text/style_1)

if [[ "${write_to}" == "clipboard" ]]; then
    grim -g "$(slurp)" - | wl-copy
elif [[ "${write_to}" == "file" ]]; then
    grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date '+%Y-%m-%d_%H:%M:%S').png"
fi
