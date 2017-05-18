local actions = require "apicast-cli.cmd"
local colors = require "ansicolors"


local function call(_, parser)
  local create_cmd = parser:command("c create", "Generates apicast application in a directory.")
    :action(actions.generator.create)

  create_cmd:usage(colors("%{bright red}Usage: apicast-cli create NAME [PATH]"))
  create_cmd:argument("name", "The name of your application.")
  create_cmd:argument("path", "The path to where you wish your app to be created."):default(".")
  create_cmd:epilog(colors([[
      Example: %{bright red} apicast-cli create 'hello_world' /var/www %{reset}
        This will create your web app under /var/www/hello_world.]]))
  return create_cmd
end

local _M = {}
local mt = { __call = call }


return setmetatable(_M, mt)
