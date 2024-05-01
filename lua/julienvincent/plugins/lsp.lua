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
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    config = function()
      require("fidget").setup({})
    end,
  },
}
