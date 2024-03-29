#!/usr/bin/env bash

# get the current desktop screen and blur it
monitors="$(hyprctl monitors -j | jq -r '.[] | .name' | tr '\n' ' ')"

screenshot_dir="$(mktemp -d)"

swaylock_args=(
    --fade-in 5
    --grace 10

    --clock
    --indicator
    --indicator-idle-visible
    --indicator-caps-lock

    # note: this is a special space (unicode U+2002), not the regular space character
    --timestr '%I:%M %p'

    --indicator-radius 90

    --font MesloLGSNF

    --inside-color 282828
    --inside-clear-color 282828
    --inside-caps-lock-color 282828
    --inside-ver-color 282828
    --inside-wrong-color 282828

    --key-hl-color ebdbb2

    --line-color 3c3c3c
    --line-clear-color 3c3c3c
    --line-caps-lock-color 3c3c3c
    --line-ver-color 3c3c3c
    --line-wrong-color 3c3c3c

    --ring-color 282828
    --ring-clear-color 282828
    --ring-caps-lock-color c89038
    --ring-ver-color 282828
    --ring-wrong-color 282828

    --separator-color 8b7b52

    --text-color ebdbb2
    --text-clear-color ebdbb2
    --text-caps-lock-color ebdbb2
    --text-ver-color ebdbb2
    --text-wrong-color ebdbb2
)

for monitor in ${monitors}; do
    screenshot_file="${screenshot_dir}/${monitor}.png"

    grim -o "${monitor}" "${screenshot_file}"
    convert -filter Gaussian -resize 20% -blur 10x3 -resize 500% "${screenshot_file}" "${screenshot_file}"

    swaylock_args+=("--image=${monitor}:${screenshot_file}")
done

# shellcheck disable=SC2068
# the word splitting that happens here is intentional
swaylock ${swaylock_args[@]}

rm -r "${screenshot_dir}"
