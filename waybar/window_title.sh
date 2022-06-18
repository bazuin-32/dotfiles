#!/bin/bash

active="$(
    hyprctl activewindow \
    | head -n 1 \
    | cut -d ' ' -f 4- \
    | sed 's/.*Invalid.*/No active window /g ; s/.$// ; s/&/&amp;/g'
)"

# if the title is too long, cut it off
if [ ${#active} -ge 80 ]; then
    active="$(echo "$active" | cut -c -80)..."
fi

echo "$active"
