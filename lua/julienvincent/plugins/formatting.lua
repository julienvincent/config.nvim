local function file_exists(file)
  return vim.loop.fs_stat(vim.fn.getcwd() .. "/" .. file) ~= nil
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    config = function()
      local conform = require("conform")

      local js_formatter = function()
        if file_exists("biome.json") and not file_exists(".prettierrc") then
          return { "biome" }
        end
        return { { "prettierd", "prettier" } }
      end

      conform.setup({
        formatters_by_ft = {
          javascript = js_formatter,
          typescript = js_formatter,
          typescriptreact = js_formatter,

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
