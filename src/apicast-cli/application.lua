local path = require 'pl.path'

local _M = {

}

local mt = { __index = _M }

function _M.new(project_root)
  local root = path.abspath(project_root or path.currentdir())

  if not root then
    return nil, 'application requires root'
  end

  return setmetatable({
    root = root
  }, mt)
end

return _M.new()
