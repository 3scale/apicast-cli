local path = require 'pl.path'

local _M = {

}

local function __tostring(t)
  return t.root
end

function _M:new(project_root)
  local root = path.abspath(project_root or path.currentdir())
  local name = path.basename(root)

  if not root then
    return nil, 'application requires root'
  end

  return setmetatable({
    root = root,
    name = name
  }, { __index = self, __tostring =__tostring })
end

return _M
