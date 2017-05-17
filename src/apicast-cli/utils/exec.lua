local ffi = require 'ffi'


local C = ffi.C
local typeof = ffi.typeof

ffi.cdef([[
int execve(const char *filename, const char *argv[], const char *envp[]);
char *strerror(int errnum);
int execvp(const char *file, const char *argv[]);
]])

local string_array_t = typeof("const char *[?]")

local function execvp(filename, ...)
  local argv = { filename, ... }
  local cargv = string_array_t(#argv + 1, argv)
  cargv[#argv] = nil
  C.execvp(filename, cargv)
  error(ffi.string(ffi.C.strerror(ffi.errno())))
end

return execvp
