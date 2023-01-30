function hzf() {
    ESC=$(printf '\033')
    BLUE="${ESC}[34m"
    BOLD="${ESC}[1m"
    NORMAL="${ESC}[0m"

    selection=$(history \
      | sed -E "s/^(\\s*)([0-9]+\\*{0,1})(\\s*)(.+)$/\1${BLUE}\2${NORMAL}\3${BOLD}\4${NORMAL}/" \
      | fzf --ansi --tac --no-sort \
      | sed -E "s/^(\\s*)([0-9]+\\*{0,1})(\\s*)(.+)$/\4/ ; s/\\\\/\\\\\\\\/g"
    )

    print -z "${selection}"
}
