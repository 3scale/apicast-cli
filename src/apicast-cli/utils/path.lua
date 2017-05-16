local path = require "pl.path"
local loader = require "luarocks.loader"
local binding = require "resty.repl"

local find_rock_directory = function()
  local file_path = loader.which("apicast-cli.utils.path")
  local f, err = file_path and io.open(file_path)

  if not f then
    return nil, err
  else
    f:close()
    return path.abspath('../../', file_path)
  end
end

local find_dev_directory = function()
  -- If we run the script apicast-cli
  -- Look for the stacktrace and the file where the function was called
  local package_path = (debug.getinfo(1).source):match("^@?(.-)/apicast%-cli/utils/path%.lua$")
  local f = package_path and io.open(path.join(package_path, "apicast-cli/utils/path.lua"), 'r')

  if f then
    f:close()
    return package_path
  end
end

local find = function()
  return find_dev_directory() or find_rock_directory()
end

return {
  find = find
}
