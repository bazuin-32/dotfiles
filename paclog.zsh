function paclog () {
	if [ "$1" = "today" ]; then
		cat /var/log/pacman.log | grep "$(date '+%Y-%m-%d')"
	else
		cat /var/log/pacman.log
	fi
}
