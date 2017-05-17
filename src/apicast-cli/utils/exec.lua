local ffi = require 'ffi'


local C = ffi.C
local typeof = ffi.typeof

ffi.cdef([[
int execve(const char *filename, const char *argv[], const char *envp[]);
int execvp(const char *file, const char *argv[]);
]])

inspect = require 'inspect'

-- used for no return value, return true for use of assert
local function retbool(ret)
  if ret == -1 then return nil, ffi.errno() end
  return true
end

local string_array_t = typeof("const char *[?]")

local function execvp(filename, ...)
  local argv = { filename, ... }
  local cargv = string_array_t(#argv + 1, argv)
  cargv[#argv] = nil
  return retbool(C.execvp(filename, cargv))
end

return execvp
