#!/bin/bash

echo_initial() {
    hyprctl activewindow -j | jq -r '.workspace .id'
}

process_event() {
    if [[ ${1%>>*} == "workspace" ]]; then
        echo ${1#*>>}
    fi
}

echo_initial

socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
    # echo "${event}"
    process_event "${event}"
done
