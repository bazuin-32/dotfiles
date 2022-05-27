function paclog () {
	if [ "$1" = "today" ]; then
		grep "$(date '+%Y-%m-%d')" /var/log/pacman.log --color=always | bat --file-name=/var/log/pacman.log
	else
		bat /var/log/pacman.log
	fi
}
