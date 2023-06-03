if vim.g.vscode then
  -- if running in vscode, use an empty config
  -- since some extensions cause problems with it
  return
end

-- reset cursor on exit
vim.api.nvim_create_autocmd(
  { "VimLeave", "VimSuspend" },
  { pattern = "*", command = "set guicursor=a:ver20-blinkwait300-blinkon200-blinkoff150" }
)

local confdir = os.getenv("HOME") .. "/.config/nvim"

package.path = confdir .. "/nvchad/?.lua;" .. confdir .. "/nvchad/lua/?/init.lua;" .. confdir .. "/nvchad/lua/?.lua;" .. package.path

require("init")
