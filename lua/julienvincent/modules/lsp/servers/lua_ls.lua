local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function dir_exists(dir)
  local stat = vim.loop.fs_stat(dir)
  return stat and stat.type == "directory"
end

-- The workspace.library config given to luals expects a table of dirs as keys
-- and true as the value. For example:
--
-- { ["/some/lua/module"] = true }
local function make_module_paths(paths)
  local result = {}
  for _, path in ipairs(paths) do
    local lua_path = path .. "/lua"
    if dir_exists(lua_path) then
      result[lua_path] = true
    end
  end
  return result
end

local function make_runtime_module_paths()
  return make_module_paths(vim.opt.runtimepath:get())
end

-- Because the vim `runtimepath` will only contain dirs of modules that have been
-- loaded - and lazy.nvim loads modules lazilly - we need to explicitly add all
-- the modules in the lazy data directory.
local function make_lazy_module_paths()
  local lazy_dir = vim.fn.stdpath("data") .. "/lazy"
  local dirs = {}
  for name, type in vim.fs.dir(lazy_dir) do
    if type == "directory" then
      table.insert(dirs, lazy_dir .. "/" .. name)
    end
  end
  -- return make_module_paths(dirs)
  return {}
end

return function()
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  return {
    name = "lua-ls",
    filetypes = { "lua" },

    cmd = mason.command("lua-language-server"),
    root_dir = fs.find_furthest_root({
      ".luarc.json",
      ".luarc.jsonc",
      ".stylua.toml",
      "stylua.toml",
    }, fs.find_closest_root({ ".git" })),

    single_file_support = true,

    settings = {
      Lua = {
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim", "hs" },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend("force", make_runtime_module_paths(), make_lazy_module_paths(), {
            -- Make the server aware of hammerspoon
            ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
          }),
        },
        telemetry = { enable = false },
      },
    },
  }
end
