local actions = require "apicast-cli.cmd"
local colors = require "ansicolors"

local function call(_, parser)
  local busted_run = parser:command("b busted", "Runs busted tests.")
    :handle_options(false)
    :argument('busted', 'busted arguments'):args('*')
    :action(actions.busted.run)

  return busted_run
end

local _M = {}
local mt = { __call = call }

return setmetatable(_M, mt)
