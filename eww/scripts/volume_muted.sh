#!/bin/bash

pactl list sinks | awk -v RS='' "/$(cat ~/.sounddev)/" | grep -E '^(\s+)Mute: ' | cut -d ':' -f 2 | tr -d '[:space:]'
