local argparse = require "argparse"
local colors = require "ansicolors"

local parser = argparse("script", colors("%{bright blue}Apicast command line utility"))
  :name(string.match(arg[0], "/*([^/]+)/*$"))
  :require_command(false)

local create_cmd = require('apicast-cli.cli.create')(parser)

local _M = {
  parser = parser,
  actions = { create_cmd }
}

function _M:call()
  local parser = self.parser

  parser:usage(parser:get_help())

  local args = parser:parse()
  return args
end

return _M
