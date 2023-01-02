#!/bin/bash

# kill any running instances if they exist
eww kill

# start eww windows for each monitor
monitors=$(hyprctl monitors -j | jq '.[] | .id')

for monitor in ${monitors}; do
    eww open bar${monitor}
    eww open menu${monitor}
done

# load weather icon data
eww update weather_icons="$(cat ~/.config/eww/modules/menu/weather_icons.json)"
