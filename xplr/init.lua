version = "0.18.0"

-- Icons
xplr.config.node_types.directory.meta.icon = ""
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = "🔗"

-- colors
xplr.config.node_types.directory.style.fg = "Yellow"


-- custom keybindings
xplr.config.modes.builtin.default.key_bindings.on_key.enter = {
	help = "enter directory or open file",
	messages = {
		{
		BashExec = [===[
		if [ -f "$XPLR_FOCUS_PATH" ]; then
			if file "$XPLR_FOCUS_PATH" | grep -q text; then
				$EDITOR "$XPLR_FOCUS_PATH"
			else
				xdg-open "$XPLR_FOCUS_PATH" & &>/dev/null
			fi
		fi
		]===]
		},
		"Enter"
	}
}
xplr.config.modes.builtin.default.key_bindings.on_key.z = {
	-- reload config?
}

-- special files
xplr.config.node_types.special[".gitignore"] = {
	meta = { icon = "" },
	style = { fg = "Red" }
}
