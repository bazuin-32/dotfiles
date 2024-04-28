#!/usr/bin/env bash

echo_initial() {
    hyprctl workspaces -j | jq -rc '[ .[].id | select( . != -99 ) ] | sort_by( . )'
}

process_event() {
    if [[ ${1%>>*} == "createworkspace" || ${1%>>*} == "destroyworkspace" ]]; then
        workspaces_json=$(hyprctl workspaces -j | jq -rc "[ .[].id | select( . != -99 ) ] | sort_by( . )")

        echo "${workspaces_json}"
    fi
}

echo_initial

socat -u "UNIX-CONNECT:${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock" - | while read -r event; do 
    # echo "${event}"
    process_event "${event}"
done
