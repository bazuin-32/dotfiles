#!/bin/bash

arc_size=$(arc_summary -r | grep ' size ' | sed -E 's/size//g;s/ //g')
memtotal=$(cat /proc/meminfo | grep -i memtotal | cut -d ' ' -f 8- | rev | cut -d ' ' -f 2-3 | rev)

arc_percent=$(echo "scale=3; ( $arc_size / ( $memtotal * 1024 ) ) * 100" | bc | awk '{ print substr($1, 1, length($1) - 2)"%" }')
arc_mib=$(echo "scale=3; $arc_size / 1024 / 1024" | bc | awk '{ print substr($1, 1, length($1) - 4)" MiB" }')

echo "$arc_percent ($arc_mib)"
