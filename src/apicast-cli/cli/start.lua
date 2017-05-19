local colors = require "ansicolors"
local configuration = require 'apicast-cli.configuration'
local exec = require('apicast-cli.utils.exec')

local pl = {
  path = require('pl.path'),
  file = require('pl.file'),
}

local Template = require('apicast-cli.template')

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

  start_cmd:option('-e --environment', "Environment to start.", 'production')
  start_cmd:flag("-t --test", "Test the nginx config")
  start_cmd:flag("-d --debug", "Debug mode. Prints more information.")
  start_cmd:flag("-D --daemon", "Daemonize.")
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
  local dir = pl.path.dirname(args.path)
  local path = pl.path.basename(args.path)
  local context = configuration:load(args.environment)

  if args.daemon then
    context.daemon = 'on'
  end

  local template = Template:new(context, dir, true)

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
end

return setmetatable(_M, mt)
