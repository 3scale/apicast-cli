local exec = require('apicast-cli.utils.exec')
local utils_path = require "apicast-cli.utils.path"
local path = require "pl.path"

local run_tests = function (args, _)
  local busted_wrapper = path.join(utils_path.find(), 'apicast-cli', 'busted_wrapper.lua')
  local spec_folder = path.join(path.currentdir(), 'spec')

  exec(busted_wrapper, { spec_folder })
end

return {
  run = run_tests
}
