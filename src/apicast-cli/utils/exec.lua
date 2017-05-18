local ffi = require 'ffi'


local C = ffi.C
local typeof = ffi.typeof

ffi.cdef([[
int execve(const char *filename, const char *argv[], const char *envp[]);
char *strerror(int errnum);
int execvp(const char *file, const char *argv[]);
]])

local string_array_t = typeof("const char *[?]")

local function execvp(filename, args)
  table.insert(args, 1, filename) -- the command name should be the first arg
  local cargv = string_array_t(#args + 1, args)
  cargv[#args] = nil
  C.execvp(filename, cargv)
  error(ffi.string(ffi.C.strerror(ffi.errno())))
end

return execvp
