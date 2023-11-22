function random-file() {
	find "${@}" -mindepth 1 -maxdepth 1 | shuf -n 1
}
