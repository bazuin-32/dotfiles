xplr.config.layouts.builtin.default.Horizontal.splits[2].Vertical = {
	config = {
		constraints = {
			{ Percentage = 50 },
			{ Percentage = 25 },
			{ Percentage = 25 },
		}
	},
	splits = {
		{ CustomContent = {
			title = "Stats",
			body = {
				DynamicTable = {
					widths = {
						{ Percentage = 30 },
						{ Percentage = 70 }
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

	node = ctx.app.focused_node

	return {
		{ bold(node.relative_path), "" },
		{ "", "" },
		{ "Permissions", xplr.fn.builtin.fmt_general_table_row_cols_2(node) .. " (" .. tostring(xplr.fn.custom.octal_perms(node.permissions)) .. ")" },
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
