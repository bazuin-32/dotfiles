#!/bin/bash

font="MesloLGS-NF-Regular"
pointsize=36
padding=120
color='#c8c8c8'

# get the current splash
splash="$(hyprctl splash)"

# get the text dimensions
# see https://stackoverflow.com/a/46705545 for the metrics thing
metrics="$(
    convert -debug annotate  xc: \
      -font "${font}" \
      -pointsize ${pointsize} \
      -annotate 0 "${splash}" \
      null: 2>&1 \
    | grep 'Metrics:' \
    | sed 's/\s//g ; s/;/\n/g ; s/:/\t/g' # format for easy parsing with awk
)"

text_width="$(awk '/width/ { print $2 }' <<< ${metrics})"
text_height="$(awk '/height/ { print $2 }' <<< ${metrics})"

# get the image dimensions
img_dims="$(magick identify -format '%[fx:w] %[fx:h]' $1)"
img_width="$(awk '{ print $1 }' <<< ${img_dims})"
img_height="$(awk '{ print $2 }' <<< ${img_dims})"

# determine where to place the text
pos_x=$(( ${img_width} - ${text_width} - ${padding} ))
pos_y=$(( ${img_height} - ${text_height} - ${padding} ))

# make a new file to write the result to
filename="$(basename -- "$1")"
new_img="$(mktemp --suffix=".${filename##*.}")"

# write the text onto the image
convert \
    -font "${font}" \
    -fill "${color}" \
    -pointsize ${pointsize} \
    -draw "text ${pos_x},${pos_y} '${splash}'" \
    $1 "${new_img}"

# get rid of current swaybg if it exists
killall swaybg

# set new wallpaper
swaybg -i "${new_img}"

# remove the file if swaybg terminates
rm "${new_img}"
