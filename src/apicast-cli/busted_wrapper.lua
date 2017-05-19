#!/usr/bin/env resty

pcall(require, 'luarocks.loader')

-- Busted command-line runner
require 'busted.runner'({ standalone = false })
