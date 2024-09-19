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
        return { "prettierd", "prettier", stop_after_first = true }
      end

      conform.setup({
        default_format_opts = {
          lsp_format = "fallback",
        },

        formatters_by_ft = {
          javascript = js_formatter,
          typescript = js_formatter,
          typescriptreact = js_formatter,

          lua = { "stylua" },
          just = { "just" },

          markdown = function()
            return { "prettier", "injected" }
          end,
        },

        formatters = {
          just = require("julienvincent.modules.formatters.just"),
          stylua = require("julienvincent.modules.formatters.stylua"),
          cljfmt = require("julienvincent.modules.formatters.cljfmt"),
          prettierd = require("julienvincent.modules.formatters.prettierd"),
          prettier = require("julienvincent.modules.formatters.prettier"),
          markdown_native = require("julienvincent.modules.formatters.markdown"),
        },
      })

      conform.formatters.injected = {
        options = {
          ignore_errors = true,
          lang_to_formatters = {
            clojure = { "cljfmt" },
          },
        },
      }

      local function format()
        local res = conform.format()
        if not res then
          return
        end

        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(string.lower(mode), "v") then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end
      end

      vim.keymap.set("", "<localleader>f", format, {
        desc = "Format current buffer",
      })
    end,
  },
}
