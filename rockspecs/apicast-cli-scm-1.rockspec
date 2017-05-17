package = "apicast-cli"
version = "scm-1"
source = {
  url = "git://github.com/3scale/apicast-cli"
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
  "penlight",
  "luafilesystem",
  "liquid-lua >= scm-1",
  "debugger-lua == scm-1",
}
build = {
  type = "builtin",
  modules = {
    ['apicast-cli.cmd'] = "src/apicast-cli/cmd.lua",
    ['apicast-cli.cli'] = "src/apicast-cli/cli.lua",
    ['apicast-cli.cmd.generator'] = "src/apicast-cli/cmd/generator.lua",
    ['apicast-cli.utils.path'] = "src/apicast-cli/utils/path.lua",
    ['apicast-cli.cli.create'] = "src/apicast-cli/cli/create.lua"
  },
  install = {
    lua = {
      ['apicast-cli.blank-app.readme'] = "src/apicast-cli/blank-app/README.md"
    },
    bin = {
      ['apicast-cli'] = "bin/apicast-cli"
    }
  }
}
