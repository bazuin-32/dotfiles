-- bookmark the currently focused item
xplr.config.modes.builtin.default.key_bindings.on_key.m = {
	help = "bookmark focused item",
	messages = {
		{
			BashExecSilently = [===[
				PTH="${XPLR_FOCUS_PATH:?}"
				if echo "${PTH:?}" >> "${XPLR_BOOKMARKS_FILE}"; then
					echo "LogSuccess: ${PTH:?} added to bookmarks" >> "${XPLR_PIPE_MSG_IN:?}"
				else
					echo "LogError: Failed to bookmark ${PTH:?}" >> "${XPLR_PIPE_MSG_IN:?}"
				fi
			]===],
		},
	},
}

-- look through bookmarks using fzf
xplr.config.modes.builtin.default.key_bindings.on_key["`"] = {
	help = "search for and go to bookmark",
	messages = {
		{
			BashExec = [===[
				echo "LogWarning: looking for bookmarks in ${XPLR_BOOKMARKS_FILE}" >> "${XPLR_PIPE_MSG_IN:?}"
				PTH=$(cat "${XPLR_BOOKMARKS_FILE}" | fzf --no-sort)
				if [ "$PTH" ]; then
					echo FocusPath: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
				fi
			]===],
		},
	},
}

-- delete a bookmark
xplr.config.modes.builtin.default.key_bindings.on_key.u = {
	help = "delete bookmark",
	messages = {{
		BashExec = [===[
			PTH="${XPLR_FOCUS_PATH:?}"
			cat "${XPLR_BOOKMARKS_FILE}" | grep -q "${PTH:?}"

			# if the focused item is not in bookmarks, show fzf selection dialog
			# to get the bookmark to remove
			if [ $? -ne 0 ]; then 
				PTH=$(cat "${XPLR_BOOKMARKS_FILE}" | fzf --no-sort)
			fi
			
			if [ "$PTH" ]; then
				if sed -i "\#${PTH:?}#d" "${XPLR_BOOKMARKS_FILE}"; then
					echo "LogSuccess: ${PTH:?} unbookmarked" >> "${XPLR_PIPE_MSG_IN:?}"
				else
					echo "LogError: Failed to unbookmark ${PTH:?}" >> "${XPLR_PIPE_MSG_IN}"
				fi
				
			fi
		]===]
	}}
}
