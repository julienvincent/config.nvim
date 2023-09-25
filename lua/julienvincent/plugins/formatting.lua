return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    config = function()
      local conform = require("conform")

      local js_formatter = { "prettierd", "prettier" }

      conform.setup({
        formatters_by_ft = {
          javascript = { js_formatter },
          typescript = { js_formatter },
          typescriptreact = { js_formatter },

          lua = { "stylua" },
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
        desc = "Format current buffer",
      })
    end,
  },
}
