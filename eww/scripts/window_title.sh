#! /usr/bin/env bash

#######################################################################################
# stolen from
# https://github.com/taylor85345/neon-hyprland-theme/blob/main/eww/scripts/appname,
# but I've modified it some
#######################################################################################

workspaces() {
    if [[ ${1/>>*/} == "activewindow" ]]; then #set focused workspace
        string=${1/*>>/}
        export title=${string/,/, }
        [[ $title == ", " ]] && unset title
    fi
}

module() {
    eww update show_window_title=false
    sleep 0.005

    if [[ "${title}" != "" ]]; then
        echo "${title/*,/}"
        eww update show_window_title=true
    fi
}

socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
    workspaces "$event"
    module
done
