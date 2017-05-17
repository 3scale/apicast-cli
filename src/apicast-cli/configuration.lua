local pl_path = require('pl.path')
local app = require('apicast-cli.application')

local _M = {
  default_environment = 'production',
  default_config = {
    lua_code_cache = 'on',
    master_process = 'off',
    worker_processes = 1,
    daemon = 'off',
  }
}

local mt = { __index = _M }

function _M.new(application)
  local app = application or app
  return setmetatable({ application = app }, mt)
end

function _M:load(env)
  local environment = env or self.default_environment
  local application = self.application
  local root = application.root
  local name = ("%s.lua"):format(environment)
  local path = pl_path.join(root, 'config', name)

  print('loading config for: ', environment, ' environment from ', path)

  local config = loadfile(path, 't', {})

  if not config then
    return nil, 'invalid config'
  end

  local table = config()

  for k,v in pairs(self.default_config) do
    if table[k] == nil then
      table[k] = v
    end
  end

  return table
end

return _M.new()
