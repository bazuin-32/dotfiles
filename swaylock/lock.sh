#!/bin/bash

# get the current desktop screen and blur it
monitors="$(hyprctl monitors -j | jq -r '.[] | .name' | tr '\n' ' ')"

screenshot_dir="$(mktemp -d)"

swaylock_args=()

for monitor in ${monitors}; do
    screenshot_file="${screenshot_dir}/${monitor}.png"

    grim -o "${monitor}" "${screenshot_file}"
    convert -filter Gaussian -resize 20% -blur 10x3 -resize 500% "${screenshot_file}" "${screenshot_file}"

    swaylock_args+=("--image=${monitor}:${screenshot_file}")
done

swaylock ${swaylock_args[@]}

rm -r "${screenshot_dir}"
