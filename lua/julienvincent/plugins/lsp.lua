local keybinds = {
  g = {
    d = { ":Telescope lsp_definitions<cr>", "Go to Definition" },
    i = { ":Telescope lsp_implementations<cr>", "Go to Impementations" },
    r = { ":Telescope lsp_references<cr>", "Symbol References" },
    t = { ":Telescope lsp_type_definitions<cr>", "Type Definitions" },
  },
  t = { ":Telescope lsp_type_definitions<cr>", "Type Definition" },
  ["<leader>"] = {
    l = {
      f = { vim.lsp.buf.format, "Format" },
      r = { vim.lsp.buf.rename, "Rename" },
      R = { ":LspRestart<cr>", "Lsp Restart" },
      I = { ":LspInfo<cr>", "Lsp Info" },
    },
  },
  K = { vim.lsp.buf.hover, "Hover doc" },
}

local servers = {
  clojure_lsp = {
    init_options = {
      codeLens = true,
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          "https://json.schemastore.org/github-workflow.json",
          ".github/workflows/*",
        },
      },
    },
  },
  tsserver = {},
  jdtls = {
    settings = {
      single_file_support = true,
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
      },
    },
  },
  jsonls = {},
  rust_analyser = {},
  lua_ls = {
    settings = {
      Lua = {
        format = {
          enable = true,
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

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = { border = "rounded" },
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = vim.tbl_keys(servers),
      },
    },

    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local cmplsp = require("cmp_nvim_lsp")

      local capabilities = cmplsp.default_capabilities()

      local options = {
        flags = {
          debounce_text_changes = 150,
        },

        capabilities = capabilities,

        on_attach = function(_, bufnr)
          local wk = require("which-key")
          wk.register(keybinds, { noremap = true, buffer = bufnr })
        end,
      }

      mason_lspconfig.setup_handlers({
        function(server_name)
          local server_opts = servers[server_name] or {}
          local opts = vim.tbl_deep_extend("force", {}, options, server_opts)
          require("lspconfig")[server_name].setup(opts)
        end,
      })
    end
  },
}
