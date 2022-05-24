xplr.config.modes.builtin.default.key_bindings.on_key.R = {
	help = "batch rename",
	messages = {
		{ BashExec = [===[
			 SELECTION=$(cat "${XPLR_PIPE_SELECTION_OUT:?}")
			 NODES=${SELECTION:-$(cat "${XPLR_PIPE_DIRECTORY_NODES_OUT:?}")}
			 if [ "$NODES" ]; then
				 echo -e "$NODES" | renamer
				 echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
			 fi
		  ]===],
		},
	},
}
