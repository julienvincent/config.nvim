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
      a = { vim.lsp.buf.code_action, "Code Action" },
      I = { ":LspInfo<cr>", "Lsp Info" },
    },
  },
  K = { vim.lsp.buf.hover, "Hover doc" },
}

local function glob_exists_in_dir(dir, globs)
  for _, glob in ipairs(globs) do
    if #vim.fn.glob(vim.api.nvim_call_function("fnamemodify", { dir, ":p" }) .. "/" .. glob) > 0 then
      return true
    end
  end
  return false
end

local function find_furthest_root(globs)
  local home = vim.fn.expand("~")

  local function traverse(path, root)
    if path == home or path == "/" then
      return root
    end

    local next = vim.fn.fnamemodify(path, ":h")

    if glob_exists_in_dir(path, globs) then
      return traverse(next, path)
    end

    return traverse(next, root)
  end

  return function(start_path)
    local result = string.match(start_path, "^%w+://")
    if result then
      return nil
    end

    local furthest_root = traverse(start_path, nil)
    if furthest_root then
      return furthest_root
    end
    return vim.fn.getcwd()
  end
end

local servers = {
  clojure_lsp = {
    root_dir = find_furthest_root({ "deps.edn", "bb.edn", "project.clj", "shadow-cljs.edn" }),
    single_file_support = true,
    init_options = {
      codeLens = true,
    },

    before_init = function(params)
      params.workDoneToken = "enable-progress"
    end,
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
    single_file_support = true,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
      },
    },
  },
  jsonls = {},
  rust_analyser = {
    settings = {
      ["rust-analyzer"] = {},
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
          wk.register(keybinds, { noremap = true, buffer = bufnr })

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
          require("lspconfig")[server_name].setup(opts)
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
