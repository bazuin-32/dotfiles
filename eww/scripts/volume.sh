#!/usr/bin/env bash

pactl list sinks | awk -v RS='' "/$(cat ~/.sounddev)/" | grep -E '^(\s+)Volume: ' | cut -d '/' -f 2 | tr -d '[:space:]'
