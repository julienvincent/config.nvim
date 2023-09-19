local servers = require("julienvincent.lsp.servers")
local keymaps = require("julienvincent.lsp.keymaps")

local icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
}

return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = true,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },

  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
    },

    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmplsp = require("cmp_nvim_lsp")

      local default_capabilities = vim.lsp.protocol.make_client_capabilities()
      default_capabilities.workspace.workspaceEdit.documentChanges = true
      local cmp_capabilities = cmplsp.default_capabilities(default_capabilities)
      local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities)

      local options = {
        flags = {
          debounce_text_changes = 150,
        },

        capabilities = capabilities,

        handlers = {
          ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics,
            { signs = true, virtual_text = false, update_in_insert = true, underline = true }
          ),
        },

        on_attach = function(client, bufnr)
          local wk = require("which-key")
          wk.register(keymaps, { noremap = true, buffer = bufnr })

          if client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
          end
          if client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
      }

      for name, icon in pairs(icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      mason_lspconfig.setup_handlers({
        function(server_name)
          local server_opts = servers[server_name] or {}
          local opts = vim.tbl_deep_extend("force", {}, options, server_opts)
          lspconfig[server_name].setup(opts)
        end,

        ["jdtls"] = function()
          local jdtls = require("jdtls")

          local registry = require("mason-registry")
          local package = registry.get_package("jdtls")

          local config = vim.tbl_deep_extend("force", {}, options, servers["jdtls"] or {}, {
            cmd = { package:get_install_path() .. "/bin/jdtls" },
          })

          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "java" },
            desc = "Start and attach jdtls",
            callback = function()
              jdtls.start_or_attach(config)
            end,
          })
        end,
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    config = function()
      require("fidget").setup({})
    end,
  },
}
