#!/bin/bash

function handle_line() {
    if [[ ${1} != "activewindow"* ]]; then
        return
    fi

    active=$(awk -F ',' '{ print $2 }' <<< "${1}")

    if [[ ${#active} -ge 60 ]]; then
        active="$(cut -c -60 <<< ${active})..."
    fi

    echo "${active}"
}

socat - /tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock | while read line; do handle_line "${line}"; done
