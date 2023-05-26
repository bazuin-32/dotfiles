-- custom keybindings
xplr.config.modes.builtin.default.key_bindings.on_key.enter = {
	help = "enter directory or open file",
	messages = {
		{
		BashExec0 = [===[
		if [ -f "$XPLR_FOCUS_PATH" ]; then
			if file -k "$XPLR_FOCUS_PATH" | grep -q text; then
				$EDITOR "$XPLR_FOCUS_PATH"
			else
				xdg-open "$XPLR_FOCUS_PATH" &>/dev/null &
			fi
		fi
		]===]
		}
	}
}
-- xplr.config.modes.builtin.default.key_bindings.on_key.z = {
-- 	-- reload config?
-- }


-- history search
xplr.config.modes.builtin.default.key_bindings.on_key.H = {
  help = "search history",
  messages = {
    --"PopMode",
    { BashExec0 = [===[
	field='\(\S\+\s*\)'
	esc=$(printf '\033')
	N="${esc}[0m"
	R="${esc}[31m"
	G="${esc}[32m"
	Y="${esc}[33m"
	B="${esc}[34m"
	pattern="s#^([0-9]*)(\s*)(.*)/(.*)#$R\1$N\2$B\3/$N$Y\4$N#g"

	PTH=$(cat "${XPLR_PIPE_HISTORY_OUT:?}" | sort -u \
	| sed 's#/*$##' \
	| sed 's/ /!#_#!/g' \
	| nl \
	| column -t \
	| sed 's/!#_#!/ /g' \
	| sed -E "${pattern}" \
	| fzf --ansi \
		--height '80%' \
		--preview="echo \"{}\" | sed 's#.*->  ##;s#[[:digit:]]  ##'| xargs exa -lbghm@ --icons --git --color=always" \
		--preview-window="right:50%" \
	| sed -E 's#.*->  ##;s#([0-9]*)(\s*)/#/#g')

        if [ "$PTH" ]; then
          echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
        fi
      ]===],
    },
  },
}

-- home/end for jump to beginning/end of directory
xplr.config.modes.builtin.default.key_bindings.on_key.home = {
	help = "Jump to beginning",
	messages = { "FocusFirst" }
}
xplr.config.modes.builtin.default.key_bindings.on_key["end"] = {
	help = "Jump to end",
	messages = { "FocusLast" }
}

-- override shell keybind to use zsh
xplr.config.modes.builtin.action.key_bindings.on_key["!"] = {
	help = "shell",
	messages = {
		{ Call0 = { command = "zsh" } },
		"ExplorePwdAsync",
		"PopMode"
	}
}
