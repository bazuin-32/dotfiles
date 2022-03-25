function paclog () {
	if [ "$1" = "today" ]; then
		cat /var/log/pacman.log | grep "$(date '+%Y-%m-%d')" --color=always
	else
		cat /var/log/pacman.log
	fi
}
