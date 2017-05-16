local path = require "pl.path"
local loader = require "luarocks.loader"

local find_rock_directory = function()
  local file_path = loader.which("apicast-cli.utils.path")
  local f, err = file_path and io.open(file_path)

  if not f then
    print("No such file " .. file_path)
    return nil, err
  else
    f:close()
    return path.abspath('../../', file_path)
  end
end

local find_dev_directory = function()
  -- If we run the script apicast-cli
  -- Look for the stacktrace and the file where the function was called
  local package_path = ((debug.getinfo(1).source):match("^@?(.-)/apicast-cli$"))
  local f = package_path and io.open(package_path.."../src/apicast-cli/utils/path.lua", 'r')
  if f then
    f:close()
    if package_path == '.' then
      return path.join(path.currentdir(),"src")
    end
  end
end

local find = function()
  return find_dev_directory() or find_rock_directory()
end

print(find_rock_directory())

return {
  find = find
}
