local lsp = require("julienvincent.lsp")

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
        -- ensure_installed = vim.tbl_keys(servers),
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },

  {
    "b0o/schemastore.nvim",
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
      lsp.setup()
    end,
  },

  {
    -- The original can be used once https://github.com/j-hui/fidget.nvim/pull/252 is merged
    "julienvincent/fidget.nvim",
    branch = "jv/uninitialized-progress",
    event = "BufReadPre",
    config = function()
      require("fidget").setup({
        progress = {
          lsp = {
            progress_ringbuf_size = 1024,
          },
        },
      })
    end,
  },
}
