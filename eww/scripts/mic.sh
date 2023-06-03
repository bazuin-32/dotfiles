#!/usr/bin/env bash

pactl list sources | awk -v RS='' "/$(cat ~/.micdev)/" | grep -E '^(\s+)Volume: ' | cut -d '/' -f 2 | tr -d '[:space:]%'
