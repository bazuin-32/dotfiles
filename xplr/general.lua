-- Icons
xplr.config.node_types.directory.meta.icon = ""
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = "🔗"

-- colors
xplr.config.node_types.directory.style.fg = "Yellow"


-- convert nanoseconds since UNIX epoch to formatted date
xplr.fn.custom.local_time = function(time)
	return os.date('%a %m/%d/%Y %I:%M %p', time / 1000000000)
end

-- custom modified time display
xplr.fn.custom.get_modified_time = function(path)
	return xplr.fn.custom.local_time(path.last_modified)
end
xplr.config.general.table.row.cols[5] = {
	format = "custom.get_modified_time",
	style = {}
}

-- convert xplr Permissions to octal
xplr.fn.custom.octal_perms = function(perms)
  local arr = xplr.util.permissions_octal(perms)
  return arr[1] .. arr[2] .. arr[3] .. arr[4]
end
