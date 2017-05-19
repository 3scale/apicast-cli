local exec = require('apicast-cli.utils.exec')
local utils_path = require "apicast-cli.utils.path"
local path = require "pl.path"

local run_tests = function ()
  local busted_wrapper = path.join(utils_path.find(), 'apicast-cli', 'busted_wrapper.lua')

  local args = {}
  for i=2, #arg do
    args[i-1] = arg[i]
  end

  exec(busted_wrapper, args)
end

return {
  run = run_tests
}
