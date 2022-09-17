pactl list sinks | grep -E '^(\s+)Volume: ' | cut -d '/' -f 2 | tr -d '[:space:]'
