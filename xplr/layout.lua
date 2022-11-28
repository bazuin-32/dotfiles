xplr.config.layouts.builtin.default.Horizontal.splits[2].Vertical = {
	config = {
		constraints = {
			{ Percentage = 50 },
			{ Percentage = 20 },
			{ Percentage = 30 },
		}
	},
	splits = {
		{ CustomContent = {
			title = "Stats",
			body = {
				DynamicTable = {
					widths = {
						{ Percentage = 33 },
						{ Percentage = 67 }
					},
					render = "custom.render_stats"
				}
			},
		  }
		},
		"Selection",
		"HelpMenu"
	}
}

xplr.fn.custom.render_stats = function(ctx)
	local bold = function (str)
		return "\x1b[1m" .. str .. "\x1b[0m"
	end

	local get_output = function (cmd, raw)
		local f = assert(io.popen(cmd, 'r'))
		local s = assert(f:read('*a'))
		f:close()
		if raw then return s end
		s = string.gsub(s, '^%s+', '')
		s = string.gsub(s, '%s+$', '')
		s = string.gsub(s, '[\n\r]+', ' ')
		return s
	end

	local node = ctx.app.focused_node

	return {
		{ bold(node.relative_path), "" },
		{ "", "" },
		{ "User", get_output("id -un " .. node.uid) .. " (" .. node.uid .. ")" },
		{ "Group", get_output("getent group " .. node.gid .. " | cut -d ':' -f 1") .. " (" .. node.gid .. ")"},
		{ "Permissions", xplr.fn.builtin.fmt_general_table_row_cols_2(node) .. " (" .. get_output("stat -c '%a' " .. node.absolute_path) .. ")" },
		{ "Size", node.human_size },
		{ "Modified", xplr.fn.custom.get_modified_time(node) },
		{ "Created", xplr.fn.custom.local_time(node.created) },
		{ "Read Only", tostring(node.is_readonly) },
		{ "", "" },
		{ "MIME Type", node.mime_essence },
		{ "", "" },
		{ "Symlink", tostring(node.is_symlink) },
		{ "Broken Symlink", tostring(node.is_broken) },
	}
end
