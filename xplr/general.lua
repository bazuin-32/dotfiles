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

xplr.fn.custom.update_img_preview = function(ctx)
  -- ***** WARNING: kinda hacky ***** --
  -- I couldn't get xplr to display sixel within its own
  -- layout structure, so I resorted to just writing to stdout
  -- "on top of" what xplr displays
  -- it's not perfect, but it works


  -- get rid of leftover processes if they exist
  -- this prevents lag due to writing to the same area
  -- of the terminal multiple times over in quick succession
  os.execute("kill $(pgrep -xn convert) &>/dev/null")
  os.execute("kill $(pgrep -xn printf) &>/dev/null")

  local lsz = ctx.layout_size
  local img_coords = { lsz.y + 15, lsz.x + 2 } -- { line, column }
  local num_chars = lsz.x + 28 - img_coords[2]
  local clear_str = string.rep(" ", num_chars)

  -- clear the area where an image was, if there was one
  if xplr.fn.custom.img_preview_displayed then
    for y = img_coords[1], img_coords[1] + 8 do
      local coord_str = string.format("\\033[%i;%iH", y, img_coords[2]) -- escape sequence to move cursor to position, see https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html)
      local cmd = string.format("printf '%s%s'", coord_str, clear_str)
      os.execute(cmd)
    end
    xplr.fn.custom.img_preview_displayed = false
  end

  local node = ctx.app.focused_node
  if node.mime_essence:find("image") then
    local coord_str = string.format("\\033[%i;%iH", img_coords[1], img_coords[2]) -- escape sequence to move cursor to position, see https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html)
    local sixel_cmd = string.format("convert %s -geometry 200x150 sixel:- 2>/dev/null", xplr.util.shell_escape(node.absolute_path))
    local cmd = string.format("printf '%s%%s%s' \"$(%s)\" &", coord_str, clear_str, sixel_cmd)
    os.execute(cmd)
    xplr.fn.custom.img_preview_displayed = true
  end
end
