local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

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
          library = {
            -- Make the server aware of Neovim runtime files
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,

            -- Make the server aware of hammerspoon
            ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
          },
        },
        telemetry = { enable = false },
      },
    },
  }
end
