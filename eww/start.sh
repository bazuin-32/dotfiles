#!/bin/bash

# kill any running instances if they exist
eww kill

# start a bar for each monitor
monitors=$(hyprctl monitors -j | jq '.[] | .id')

for monitor in ${monitors}; do
    eww open bar${monitor}
done

# enable battery module if a battery is present
[[ -e /sys/class/power_supply/BAT0 ]] && eww update show_battery=true
