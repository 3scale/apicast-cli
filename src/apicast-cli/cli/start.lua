local colors = require "ansicolors"
local Liquid = require 'liquid'
local configuration = require 'apicast-cli.configuration'
local exec = require('apicast-cli.utils.exec')

local pl = {
  path = require('pl.path'),
  file = require('pl.file'),
}

local Template = require('apicast-cli.template')

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

local _M = {
  openresty = { 'openresty-debug', 'openresty', 'nginx' },
  log_levels = { 'emerg', 'alert', 'crit', 'error', 'warn', 'notice', 'info', 'debug' },
  log_level = 5, -- warn
  log_file = 'stderr',
}

local function call(m, parser)
  local start_cmd = parser:command("s start", "Start Nginx")
  :action(m.start)

  start_cmd:usage(colors("%{bright red}Usage: apicast-cli start [PATH]"))
  start_cmd:argument("path", "The name of your application.", 'nginx/main.conf.liquid')
  start_cmd:flag("-t --test", "Test the nginx config")
  start_cmd:flag("-d --debug", "Debug mode. Prints more information.")
  start_cmd:flag('-v --verbose', "Increase logging verbosity."):count(("0-%s"):format(#(_M.log_levels) - _M.log_level))
  start_cmd:flag('-q --quiet', "Decrease logging verbosity."):count(("0-%s"):format(_M.log_level - 1))

  start_cmd:epilog(colors([[
      Example: %{bright red} apicast-cli start path/to/template.liquid%{reset}
        This will create start nginx using tempalte path/to/template.liquid.]]))
  return start_cmd
end

local mt = { __call = call }

local function pick_openesty(candidates)
  for i=1, #candidates do
    local ok = os.execute(('%s -V 2>/dev/null'):format(candidates[i]))

    if ok then
      return candidates[i]
    end
  end

  error("could not find openresty executable")
end

function _M.start(args)
  local openresty = pick_openesty(_M.openresty)
  local path = args.path
  local attributes = lfs.attributes(path)
  local context = configuration:load()
  local template = Template:new(context)

  if attributes then
    local mode = attributes.mode

    if mode == 'file' then

      local config = template:render(path)

      local tmp = pl.path.tmpname()

      pl.file.write(tmp, config)

      local log_level = _M.log_levels[_M.log_level + args.verbose - args.quiet]
      local log_file = args.log or _M.log_file
      local global = {
        ('error_log %s %s'):format(log_file, log_level)
      }

      local cmd = { '-c', tmp, '-g', table.concat(global, '; ') .. ';' }

      if args.test then
        table.insert(cmd, args.debug and '-T' or '-t')
      end

      exec(openresty, cmd)
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
