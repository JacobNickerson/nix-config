require("autostart")
require("env")
require("input")
require("keybinds")
require("look-and-feel")
require("misc")
require("programs")
require("window-rules")

local profile_name = require("profile")
local ok, profile = pcall(require, "profiles." .. profile_name)
if not ok then
  profile = {}
end
