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
xplr.config.modes.builtin.default.key_bindings.on_key.z = {
	-- reload config?
}


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
