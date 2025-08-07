local function file_exists(file)
  return vim.loop.fs_stat(vim.fn.getcwd() .. "/" .. file) ~= nil
end

return {
  {
    "stevearc/conform.nvim",
    event = "BufReadPost",
    keys = { "<localleader>f" },
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
          css = js_formatter,

          lua = { "stylua" },
          just = { "just" },
          toml = { "taplo" },

          sql = { "sqruff" },

          clojure = function(buf)
            local clients = vim.lsp.get_clients({ bufnr = buf })

            local supported = false
            for _, client in ipairs(clients) do
              if client:supports_method("textDocument/formatting") then
                supported = true
                break
              end
            end

            if supported then
              return {
                lsp_format = "first",
                "clojure_comments",
                "injected",
              }
            end

            -- When clojure-lsp is attached in single-file mode (no root_dir)
            -- it drops its support for formatting, which is a bit stupid.
            --
            -- By default I want to use clojure-lsp for formatting, but as a
            -- fallback I want to use cljfmt.
            return {
              "cljfmt",
              "clojure_comments",
              "injected",
            }
          end,

          markdown = function()
            return { "prettier", "injected" }
          end,
          mdx = function()
            return { "prettier", "injected" }
          end,

          http = function()
            return { "injected" }
          end,
        },

        formatters = {
          just = require("julienvincent.modules.formatters.just"),
          stylua = require("julienvincent.modules.formatters.stylua"),
          cljfmt = require("julienvincent.modules.formatters.cljfmt"),
          prettierd = require("julienvincent.modules.formatters.prettierd"),
          prettier = require("julienvincent.modules.formatters.prettier"),
          clojure_comments = require("julienvincent.modules.formatters.clojure.comments"),
          injected = require("julienvincent.modules.formatters.injected"),
          taplo = require("julienvincent.modules.formatters.taplo"),
          sqruff = require("julienvincent.modules.formatters.sqruff"),
        },
      })

      local function format()
        conform.format({ async = true }, function(err)
          if err then
            return
          end

          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(string.lower(mode), "v") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
          end
        end)
      end

      vim.keymap.set("", "<localleader>f", format, {
        desc = "Format current buffer",
      })
    end,
  },
}
