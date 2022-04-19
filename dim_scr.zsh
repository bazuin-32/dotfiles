# gradually dims the screen
dim_scr() {
	local monitors=$(xrandr --listmonitors | grep -v 'Monitors:' | rev | cut -d ' ' -f 1 | rev | tr '\n' ' ')

	return 0 # !! REMOVE !!

        for i in $(seq 1 -0.01 0.01); do
		for mon in $monitors; do
			xrandr --output $mon --brightness $i
		done
	done
}
