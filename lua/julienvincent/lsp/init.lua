local servers = require("julienvincent.lsp.servers")
local keymaps = require("julienvincent.lsp.keymaps")

local jdtls = require("julienvincent.lsp.servers.jdtls")

local M = {}

local icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
}

function M.setup()
  local mason_lspconfig = require("mason-lspconfig")
  local lspconfig = require("lspconfig")
  local cmplsp = require("cmp_nvim_lsp")

  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_capabilities = cmplsp.default_capabilities(default_capabilities)
  local capabilities = vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities, {
    workspace = {
      workspaceEdit = {
        documentChanges = true,
      },
    },
  })

  local options = {
    flags = {
      debounce_text_changes = 150,
    },

    capabilities = capabilities,

    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        signs = true,
        virtual_text = false,
        update_in_insert = true,
        underline = true,
      }),
    },

    on_attach = function(_, bufnr)
      keymaps.setup_on_attach_keybinds(bufnr)
    end,
  }

  for name, icon in pairs(icons.diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  local server_configs = servers.resolve_server_configs()

  local function setup_server(name)
    local server_opts = server_configs[name] or {}
    local opts = vim.tbl_deep_extend("force", {}, options, server_opts)
    lspconfig[name].setup(opts)
  end

  mason_lspconfig.setup_handlers({
    setup_server,

    ["jdtls"] = function()
      local server_opts = server_configs["jdtls"] or {}
      local opts = vim.tbl_deep_extend("force", {}, options, server_opts)
      jdtls.mason_setup_handler(opts)
    end,
  })

  require("which-key").register(keymaps.which_key_keys)
  keymaps.setup_global_keybinds()
end

return M
