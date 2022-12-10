if vim.g.vscode then
  -- if running in vscode, use an empty config
  -- since some extensions cause problems with it
  return
end

local confdir = os.getenv("HOME") .. "/.config/nvim"

package.path = confdir .. "/nvchad/?.lua;" .. confdir .. "/nvchad/lua/?/init.lua;" .. confdir .. "/nvchad/lua/?.lua;" .. package.path

require("init")
