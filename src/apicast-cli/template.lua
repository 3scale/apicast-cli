local _M = {}

local pl = { dir = require('pl.dir'), path = require('pl.path'), file = require('pl.file') }
local Liquid = require 'liquid'

local Lexer = Liquid.Lexer
local Parser = Liquid.Parser
local Interpreter = Liquid.Interpreter
local Lazy = Liquid.Lazy
local InterpreterContext = Liquid.InterpreterContext
local FileSystem = Liquid.FileSystem

local LazyFileSystem = {}

function LazyFileSystem:new(template)
  local filesystem = setmetatable({}, {
    _index = function(t, k)
      local dirs = {}
      for dir in pl.dir.getfiles(pl.path.join(template.root, k)) do
        print(dir)
        if dir ~= '.' and dir ~= '..' then
          table.insert(dirs, k .. '/' .. dir)
        end
      end
      return dirs
    end
  })

  return Lazy:new(filesystem)
end

function _M:new(config, dir)
  local instance = setmetatable({}, { __index = self })

  instance.root = pl.path.abspath(dir or pl.path.currentdir())

  instance.filesystem = FileSystem:new(function(path)
    return instance:read(path)
  end)

  local fs = LazyFileSystem:new(instance)

  instance.context = InterpreterContext:new(setmetatable({ fs = fs }, { __index = config }))

  return instance
end

function _M:read(template_name)
  local root = self.root

  return pl.file.read(pl.path.join(root, template_name))
end


function _M:render(template_name)
  local template = self:read(template_name)
  return self:interpret(template)
end

function _M:interpret(template)
  local lexer = Lexer:new(template)
  local parser = Parser:new(lexer)
  local interpreter = Interpreter:new(parser)
  local context = self.context
  local filesystem = self.filesystem

  return interpreter:interpret(context, nil, nil, filesystem)
end

return _M
