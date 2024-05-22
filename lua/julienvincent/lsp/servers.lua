local utils = require("julienvincent.lsp.utils")

local M = {}

M.servers = {
  ltex = {
    settings = {
      ltex = {
        checkFrequency = "save",
        diagnosticSeverity = "warning",
        language = "en-GB",
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en-GB",
        },
      },
    },
  },
  clojure_lsp = function()
    return {
      root_dir = utils.find_furthest_root(
        { "deps.edn", "bb.edn", "project.clj", "shadow-cljs.edn" },
        utils.fallback_fn_tmp_dir
      ),
      single_file_support = true,
      init_options = {
        codeLens = true,
        ["project-specs"] = {
          {
            ["project-path"] = "deps.edn",
            ["classpath-cmd"] = { "kmono", "cp" },
          },
        },
      },

      before_init = function(params)
        params.workDoneToken = "enable-progress"
      end,
    }
  end,
  yamlls = function()
    return {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = "",
          },
          schemas = require("schemastore").yaml.schemas({
            select = { "GitHub Workflow" },
          }),
        },
      },
    }
  end,
  jsonls = function()
    return {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  tsserver = {},
  jdtls = {
    single_file_support = true,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
      },
    },
  },
  spicedb = {},
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = { ".embuild", "target", ".git" },
        },
      },
    },
  },
  lua_ls = function()
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    return {
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
              -- TODO: This no longer works in neovim 0.10.x
              -- vim.fn.expand("$VIMRUNTIME/lua"),
              -- vim.fn.stdpath("config") .. "/lua",

              -- Make the server aware of hammerspoon
              ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
            },
          },
          telemetry = { enable = false },
        },
      },
    }
  end,
}

function M.resolve_server_configs()
  local servers = {}
  for name, config in pairs(M.servers) do
    if type(config) == "function" then
      servers[name] = config()
    else
      servers[name] = config
    end
  end

  return servers
end

return M
