-- extension-based styles
xplr.config.node_types.extension.pdf = {
	meta = { icon = "" },
	style = { fg = { Rgb = { 115, 115, 215 } } }
}

xplr.config.node_types.extension.xlsx = {
  meta = { icon = "" },
  style = xplr.config.node_types.extension.pdf.style
}

xplr.config.node_types.extension.json = {
	meta = { icon = "" }
}

xplr.config.node_types.extension.mp4 = {
	meta = { icon = "" },
	style = { fg = { Rgb = { 160, 100, 220 } } }
}

xplr.config.node_types.extension.mov = xplr.config.node_types.extension.mp4
xplr.config.node_types.extension.MP4 = xplr.config.node_types.extension.mp4
