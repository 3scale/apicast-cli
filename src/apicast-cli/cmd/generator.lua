local utils_path = require "apicast-cli.utils.path"
local path = require "pl.path"
local dir = require "pl.dir"
local file = require 'pl.file'
local stringx = require 'pl.stringx'

local Template = require 'apicast-cli.template'
local project = require 'apicast-cli.project'

local function tmpname()
  local tmp = path.tmpname()

  assert(file.delete(tmp))

  return tmp
end

local function copy_blank_app(destination, fun)
  local new_app = tostring(destination)
  local blank_app = 'blank-app'
  local raw_app = project:new(path.join(utils_path.find(), 'apicast-cli', blank_app))
  local tmp = tmpname()

  local template = Template:new()

  local function tmppath(dest)
    return path.join(new_app, path.relpath('/' .. path.relpath(dest, tmp), tostring(raw_app)))
  end

  local force = true
  local copy_file = function(src, dest)
    -- replace all occurances of blank-app in the path with the project name
    local dst = stringx.replace(tmppath(dest), blank_app, destination.name)
    local dirname = path.dirname(dst)

    if path.exists(dst) then
      if force then
        file.delete(dst)
      else
        return nil, 'path exists'
      end
    end

    local ok, err

    if not path.isdir(dirname) then
      ok, err = dir.makepath(dirname)

      if fun then
        fun(dirname, err)
      else
        assert(ok, err)
      end
    end

    ok, err = file.write(dst, template:render(src))

    if fun then
      fun(dst, err)
    else
      assert(ok, err)
    end
  end

  return dir.clonetree(tostring(raw_app), tmp, copy_file)
end

local create_new_project = function (args, _)
  local opts = args or {}
  local name = opts.name or 'new-app'
  name = string.gsub(name:lower(), ' ', '-')
  local destiny = opts.path or path.currentdir()
  local new_app = project:new(path.join(destiny, name))

  print('Generating new project into ', tostring(new_app))
  copy_blank_app(new_app, function(path, err)
    if err then
      print('ERROR: failed to create ', path, ': ', err)
    else
      print('ok ', path)
    end
  end)

  print('done!')
  os.exit(0)
end

return {
  create = create_new_project
}
