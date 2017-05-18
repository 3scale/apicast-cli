local path = require "pl.path"
local persist = require "luarocks.persist"
local type_check = require "luarocks.type_check"

local version_string = function(version , revision)
  return table.concat({version, revision or "1"}, "-")
end

local filename_with_version = function(name, version, revision)
  return table.concat({name, version_string(version, revision)}, "-") .. ".rockspec"
end

local rockspec = function(flags)
  -- verify_package_name(flags["name"])

  local defaults = {__index = {
      version = "scm",
      url = "*** please add URL for source tarball, zip or repository here ***",
      summary = "*** please specify description summary ***",
      detailed = "*** please specify description description ***",
      homepage = "*** please specify description homepage ***",
      license = "MIT",
  }}
  setmetatable(flags, defaults)
  local package = flags["name"]:lower()

  local rockspec = {
    rockspec_format = "1.1",
    package = package,
    -- name = flags["name"],
    version = version_string(flags["version"], flags["revision"]),
    source = {
      url = flags["url"],
      tag = flags["tag"],
    },
    description = {
      summary = flags["summary"],
      detailed = flags["detailed"],
      homepage = flags["homepage"],
      license = flags["license"],
    },
    dependencies = {
      "apicast-cli == scm-1",
      "apicast == scm-1"
    },
    -- List files
    build = {
      type = "builtin",
      modules = {
        [package .. ".config.development"] = "config/development.lua",
        [package .. ".config.production"] = "config/production.lua",
        [package .. ".init"] = "src/" .. package .. "/init.lua",
      },
      install = {
      },
    },
  }
  return rockspec
end

local generate_rockspec = function(flags)
  local spec = rockspec(flags)
  local filename = filename_with_version(flags["name"], flags["version"], flags["revision"])
  local dest = flags["dest"] or path.currentdir()

  persist.save_from_table(path.join(dest, filename), spec, type_check.rockspec_order)
  return spec
end

return {
  generate = generate_rockspec
}
