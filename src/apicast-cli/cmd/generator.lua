local utils_path = require "apicast-cli.utils.path"
local path = require "pl.path"
local dir = require "pl.dir"

local create_new_project = function (args, _)
  local opts = args or {}
  local name = opts.name or 'new-app'
  name = string.gsub(name:lower(), ' ', '-')
  local destiny = opts.path or path.currentdir()

  local raw_app = path.join(utils_path.find(), 'apicast-cli/blank-app')
  local new_app = path.join(destiny, name)
  local command = {"cp", "-a", raw_app, new_app}
  print('Generating new project into ' .. new_app)
  assert(os.execute(table.concat(command, " ")))
  print('done!')
  os.exit(0)
end

return {
  create = create_new_project
}
