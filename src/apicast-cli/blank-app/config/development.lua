local lr_path, lr_cpath, lr_bin = require('luarocks.cfg').package_paths()

return {
  worker_processes = '1',
  master_process = 'off',
  lua_code_cache = 'off',
  lua_path = "./src/?.lua;./src/?/init.lua;"..lr_path,
  lua_cpath = lr_cpath,
  env = {
    PATH = lr_bin -- this probably also needs to use the previous value
  }
}
