local lfs = require 'lfs'

local _M  = {}

function _M.create_new_project(args, _)
  local opts = args or {}
  local name = string.gsub((opts.name or 'new-app'):lower(), ' ', '_')
  local current_dir = lfs.currentdir()
  local destiny = opts.path or current_dir

  local raw_app = current_dir .. '/blank-app'
  local new_app = destiny .. "/" .. name
  assert(os.execute("cp -a '" .. raw_app .. "' '" .. new_app .. "'"))
  print('done!')
  os.exit(0)
end

return _M
