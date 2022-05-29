local confdir = os.getenv("HOME") .. "/.config/nvim"

package.path = confdir .. "/nvchad/?.lua;" .. confdir .. "/nvchad/lua/?/init.lua;" .. confdir .. "/nvchad/lua/?.lua;" .. package.path

require("init")
