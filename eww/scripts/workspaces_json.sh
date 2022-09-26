process_event() {
    if [[ ${1%>>*} == "workspace" ]]; then
        workspaces_json=$(hyprctl workspaces -j | jq -rc "[ .[].id | select( . != -99 ) ] | sort_by( . )")
        
        if [[ "${workspaces_json}" == "${prev_workspaces_json}" ]]; then
            return
        fi

        prev_workspaces_json="${workspaces_json}"

        echo "${workspaces_json}"
    fi
}
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r event; do 
    # echo "${event}"
    process_event "${event}"
done
