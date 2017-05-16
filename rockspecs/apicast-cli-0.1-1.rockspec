package = "apicast-cli"
version = "0.1-1"
source = {
  -- url = "https://github.com/3scale/apicast-cli"
  url = "."
}
description = {
  summary = "A Lua tool to bootstrap [apicast](https://github.com/3scale/apicast) project.",
  detailed = [[
  apicast-cli is the tool to generate your Openresty project using apicast
  ]],
  homepage = "https://github.com/3scale/apicast-cli",
  license = "Apache License 2.0"
}
dependencies = {
  "lua >= 5.1, < 5.3",
  "argparse",
  "ansicolors",
  "luafilesystem"
}
build = {
  type = "builtin",
  modules = {
    ['apicast-cli.cmd'] = "src/apicast-cli/cmd.lua",
    ['apicast-cli.cmd.generator'] = "src/apicast-cli/cmd/generator.lua"
  },
  bin = {
    ['apicast-cli'] = "src/bin/apicast-cli"
  }
}
