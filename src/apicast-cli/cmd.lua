local generator = require "apicast-cli.cmd.generator"
local busted = require "apicast-cli.cmd.busted"

local _M = {
  generator = generator,
  busted = busted
}

return _M
