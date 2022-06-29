-- custom keybindings
xplr.config.modes.builtin.default.key_bindings.on_key.enter = {
	help = "enter directory or open file",
	messages = {
		{
		BashExec = [===[
		if [ -f "$XPLR_FOCUS_PATH" ]; then
			if file -k "$XPLR_FOCUS_PATH" | grep -q text; then
				$EDITOR "$XPLR_FOCUS_PATH"
			else
				xdg-open "$XPLR_FOCUS_PATH" & &>/dev/null
			fi
		fi
		]===]
		}
	}
}
-- xplr.config.modes.builtin.default.key_bindings.on_key.z = {
-- 	-- reload config?
-- }


-- re-assign keybindings for deletion, this time without the extra
-- `[enter to contiune]` message
xplr.config.modes.builtin.delete.key_bindings.on_key.d = {
	help = "delete",
	messages = {
	{
		BashExec = [===[
		  (while IFS= read -r line; do
		  if [ -d "$line" ] && [ ! -L "$line" ]; then
			if rmdir -v -- "${line:?}"; then
			  echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
			else
			  echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
			fi
		  else
			if rm -v -- "${line:?}"; then
			  echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
			else
			  echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
			fi
		  fi
		  done < "${XPLR_PIPE_RESULT_OUT:?}")
		  echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
		]===],
	},
	"PopMode",
	}
}

xplr.config.modes.builtin.delete.key_bindings.on_key.D = {
	help = "force delete",
	messages = {
	{
		BashExec = [===[
		  (while IFS= read -r line; do
		  if rm -rfv -- "${line:?}"; then
			echo LogSuccess: $line deleted >> "${XPLR_PIPE_MSG_IN:?}"
		  else
			echo LogError: Failed to delete $line >> "${XPLR_PIPE_MSG_IN:?}"
		  fi
		  done < "${XPLR_PIPE_RESULT_OUT:?}")
		  echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
		]===],
	},

	"PopMode",
	}
}

-- history search
xplr.config.modes.builtin.default.key_bindings.on_key.H = {
  help = "search history",
  messages = {
    --"PopMode",
    { BashExec = [===[
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
		{ Call = { command = "zsh" } },
		"ExplorePwdAsync",
		"PopMode"
	}
}
