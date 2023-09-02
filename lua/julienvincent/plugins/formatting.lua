return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    config = function()
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "prettierd", "prettier" },
          typescript = { "prettierd", "prettier" },
          just = { "just" },
        },

        formatters = {
          just = {
            command = "just",
            args = {
              "--fmt",
              "--unstable",
              "-f",
              "$FILENAME",
            },
            stdin = false,
          },
        },
      })

      local function format()
        conform.format({
          lsp_fallback = true,
        })
      end

      vim.keymap.set("n", "<localleader>f", format, {
        desc = "Cycle paste backwards",
      })
    end,
  },
}
