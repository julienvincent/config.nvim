return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    lazy = true,
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
        PATH = "skip",
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
    "j-hui/fidget.nvim",
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
