-- Icons
xplr.config.node_types.directory.meta.icon = ""
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = "🔗"

-- colors
xplr.config.node_types.directory.style.fg = "Yellow"


-- custom modified time display
xplr.fn.custom.get_modified_time = function(path)
	return tostring(os.date('%a %m/%d/%Y %I:%M %p', path.last_modified / 1000000000))
end
xplr.config.general.table.row.cols[5] = {
	format = "custom.get_modified_time",
	style = {}
}
