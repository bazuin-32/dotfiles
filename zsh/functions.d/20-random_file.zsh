function random-file() {
	/usr/bin/find "${@}" -mindepth 1 -maxdepth 1 | shuf -n 1
}
