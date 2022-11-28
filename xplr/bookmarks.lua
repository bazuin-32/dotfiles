-- bookmark the currently focused item
xplr.config.modes.builtin.default.key_bindings.on_key.m = {
	help = "bookmark focused item",
	messages = {
		{
			BashExecSilently0 = [===[
				PTH="${XPLR_FOCUS_PATH:?}"
				
				cat "${XPLR_BOOKMARKS_FILE}" | grep -q "${PTH:?}"
				if [ $? -eq 0 ]; then
					echo "LogWarning: ${PTH:?} is already in bookmarks, skipping duplicate" >> "${XPLR_PIPE_MSG_IN:?}"
				elif echo "${PTH:?}" >> "${XPLR_BOOKMARKS_FILE}"; then
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
	help = "go to bookmark",
	messages = {
		"PopMode",
		{ BashExec0 = [===[
			field='\(\S\+\s*\)'
			esc=$(printf '\033')
			N="${esc}[0m"
			R="${esc}[31m"
			G="${esc}[32m"
			Y="${esc}[33m"
			B="${esc}[34m"
			pattern="s#^([0-9]*)(\s*)(.*)/(.*)#$R\1$N\2$B\3/$N$Y\4$N#g"

			PTH=$(cat "${XPLR_BOOKMARKS_FILE}" \
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

			if [ -f "$PTH" ]; then
				echo FocusPath: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
			elif [ -d "$PTH" ]; then
				echo ChangeDirectory: "'"${PTH:?}"'" >> "${XPLR_PIPE_MSG_IN:?}"
			else
				echo LogError: "'"${PTH:?}"'" is not a file or directory >> "${XPLR_PIPE_MSG_IN:?}"
			fi
		  ]===]
		},
	}
}

-- delete a bookmark
xplr.config.modes.builtin.default.key_bindings.on_key.u = {
	help = "delete bookmark",
	messages = {{
		BashExec0 = [===[
			PTH="${XPLR_FOCUS_PATH:?}"
			cat "${XPLR_BOOKMARKS_FILE}" | grep -q "${PTH:?}"

			# if the focused item is not in bookmarks, show fzf selection dialog
			# to get the bookmark to remove
			if [ $? -ne 0 ]; then 
				field='\(\S\+\s*\)'
				esc=$(printf '\033')
				N="${esc}[0m"
				R="${esc}[31m"
				G="${esc}[32m"
				Y="${esc}[33m"
				B="${esc}[34m"
				pattern="s#^([0-9]*)(\s*)(.*)/(.*)#$R\1$N\2$B\3/$N$Y\4$N#g"

				PTH=$(cat "${XPLR_BOOKMARKS_FILE}" \
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
