local argparse = require "argparse"
local colors = require "ansicolors"

local parser = argparse("script", colors("%{bright blue}Apicast command line utility"))
  :name(string.match(arg[0], "/*([^/]+)/*$"))
  :require_command(true)

local create_cmd = require('apicast-cli.cli.create')
local start_cmd = require('apicast-cli.cli.start')
local busted_cmd = require('apicast-cli.cli.busted')

local _M = {
  parser = parser,
  actions = { create_cmd, start_cmd, busted_cmd }
}

function _M:call()
  local parser = self.parser
  local actions = self.actions

  for i=1, #actions do
    actions[i](parser) -- initialize actions
  end

  parser:usage(parser:get_help())

  local args = parser:parse()
  return args
end

return _M
