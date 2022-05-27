xplr.config.layouts.builtin.default.Horizontal.splits[2].Vertical = {
	config = {
		constraints = {
			{ Percentage = 70 },
			{ Percentage = 30 },
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
		"Selection"
	}
}

xplr.fn.custom.render_stats = function(ctx)
	node = ctx.app.focused_node
	return {
		{ node.relative_path, "" },
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
