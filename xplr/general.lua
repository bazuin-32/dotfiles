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
	local octal = 0

	if perms.user_read then
		octal = octal + 400
	end
	if perms.user_write then
		octal = octal + 200
	end
	if perms.user_execute then
		octal = octal + 100
	end

	if perms.group_read then
		octal = octal + 40
	end
	if perms.group_write then
		octal = octal + 20
	end
	if perms.group_execute then
		octal = octal + 10
	end

	if perms.other_read then
		octal = octal + 4
	end
	if perms.other_write then
		octal = octal + 2
	end
	if perms.other_execute then
		octal = octal + 1
	end

	return octal
end
