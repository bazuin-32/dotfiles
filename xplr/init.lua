version = "0.20.0"

-- add the xplr config dir to `package.path` so that
-- we can `require` other files from it
package.path = package.path .. ';' .. os.getenv("HOME") .. '/.config/xplr/?.lua;'
require("general") 	-- general settings
require("extensions") 	-- styling based on specific file extension
require("special") 	-- styling for special files, e.g. `.gitignore`
require("keybindings") 	-- custom keybindings
require("bookmarks") 	-- adds the ability to bookmark files
require("batch_rename") -- add the ability to batch rename files
require("fuzzy_search") -- add the ability to recursively fuzzy search files
require("layout")	-- customizes layout
