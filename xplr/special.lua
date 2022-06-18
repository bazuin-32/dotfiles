-- git files
xplr.config.node_types.special[".git"] = {
	meta = { icon = " " },
        style = { fg = "Red" }
}
xplr.config.node_types.special[".gitignore"] = {
	meta = { icon = "" },
	style = { fg = "Red" }
}
xplr.config.node_types.special[".gitmodules"] = xplr.config.node_types.special[".gitignore"]
