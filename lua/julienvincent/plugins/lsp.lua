local servers = require("julienvincent.lsp.servers")
local keymaps = require("julienvincent.lsp.keymaps")
local utils = require("julienvincent.lsp.utils")

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
          require("which-key").register(keymaps, {
            noremap = true,
            buffer = bufnr,
          })
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
          local jdtls_install_dir = package:get_install_path()

          local config_dir = "config_mac"
          if vim.fn.has("linux") == 1 then
            config_dir = "config_linux"
          end

          local home_dir = os.getenv("HOME")
          local project_id = vim.fn.sha256(vim.fn.getcwd())
          local data_dir = home_dir .. "/.local/share/nvim/jdtls/projects/" .. project_id

          local launcher = utils.find_file_by_glob(jdtls_install_dir .. "/plugins", "org.eclipse.equinox.launcher_*")

          local cmd = {
            "java",

            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",

            "-jar",
            launcher,

            "-configuration",
            jdtls_install_dir .. "/" .. config_dir,

            "-data",
            data_dir,
          }

          local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
          local config = vim.tbl_deep_extend("force", {}, options, servers["jdtls"] or {}, {
            cmd = cmd,

            init_options = {
              extendedClientCapabilities = vim.tbl_deep_extend("force", {}, extendedClientCapabilities, {
                resolveAdditionalTextEditsSupport = true,
              }),
            },
          })

          local libs
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "java" },
            desc = "Start and attach jdtls",
            callback = function()
              local cwd = vim.fn.getcwd()
              if not libs then
                libs = utils.find_third_party_libs("/Users/julienvincent/.m2", cwd)
              end
              jdtls.start_or_attach(vim.tbl_deep_extend("force", {}, config, {
                settings = {
                  java = {
                    project = {
                      referencedLibraries = libs,
                    },
                  },
                },
              }))
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
