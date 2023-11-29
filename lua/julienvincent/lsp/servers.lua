local utils = require("julienvincent.lsp.utils")

local M = {}

M.servers = {
  clojure_lsp = {
    root_dir = utils.find_furthest_root({ "deps.edn", "bb.edn", "project.clj", "shadow-cljs.edn" }),
    single_file_support = true,
    init_options = {
      codeLens = true,
    },

    before_init = function(params)
      params.workDoneToken = "enable-progress"
    end,
  },
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
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = { ".embuild", "target", ".git" },
        },
      },
    },
  },
  lua_ls = {
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
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
}

function M.resolve_server_configs()
  local servers = {}
  for name, config in ipairs(M.servers) do
    if type(config) == "function" then
      table.insert(servers, name, config())
    else
      table.insert(servers, name, config)
    end
  end

  return servers
end

return M
