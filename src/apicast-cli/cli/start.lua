local colors = require "ansicolors"
local Liquid = require 'liquid'
local configuration = require 'apicast-cli.configuration'
local exec = require('apicast-cli.utils.exec')

local pl = {
  path = require('pl.path'),
  file = require('pl.file'),
}

local Lexer = Liquid.Lexer
local Parser = Liquid.Parser
local Interpreter = Liquid.Interpreter
local Lazy = Liquid.Lazy
local InterpreterContext = Liquid.InterpreterContext

local lfs = require('lfs')

local function say(format, ...)
  return print(string.format(format, ...))
end

local function read(path)
  local attributes = lfs.attributes(path)

  if attributes and attributes.mode == 'file' then
    local file, err = io.open(path, 'r')

    if file then
      local content = file:read('*a')

      file:close()
      return content
    else
      return nil, err
    end
  else
    return nil, 'not a file'
  end
end

function Liquid.FileSystem.get(location)
  return read(location) or ''
end

local function call(m, parser)
  local create_cmd = parser:command("s start", "Start Nginx")
  :action(m.start)

  create_cmd:usage(colors("%{bright red}Usage: apicast-cli start [PATH]"))
  create_cmd:argument("path", "The name of your application.", 'nginx/main.conf.liquid')
  -- create_cmd:argument("path", "The path to where you wish your app to be created."):default(".")
  create_cmd:epilog(colors([[
      Example: %{bright red} apicast-cli start path/to/template.liquid%{reset}
        This will create start nginx using tempalte path/to/template.liquid.]]))
  return create_cmd
end

local _M = { }
local mt = { __call = call }

local function render(template, config)
  local filesystem = setmetatable({}, {
    __index = function(t, k)
      local dirs = {}
      for dir in lfs.dir(k) do
        if dir ~= '.' and dir ~= '..' then
          table.insert(dirs, k .. '/' .. dir)
        end
      end
      return dirs
    end
  })
  local fs = Lazy:new(filesystem, {})
  local lexer = Lexer:new(template)
  local parser = Parser:new(lexer)
  local interpreter = Interpreter:new(parser)
  local context = InterpreterContext:new(setmetatable({ fs = fs }, { __index = config }))

  return interpreter:interpret(context)
end

function _M.start(args)
  local path = args.path
  local attributes = lfs.attributes(path)
  local context = configuration:load()

  if attributes then
    local mode = attributes.mode

    if mode == 'file' then
      local config = render(read(path), context)
      local tmp = pl.path.tmpname()

      pl.file.write(tmp, config)

      exec('openresty', '-c', tmp)
    else
      say('path %s is not a file but a %s', path, mode)
      os.exit(1)
    end
  else
    say('path %s does not exist', path)
    os.exit(1)
  end
end

return setmetatable(_M, mt)
