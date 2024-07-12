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
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },

  {
    "b0o/schemastore.nvim",
    lazy = true,
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
