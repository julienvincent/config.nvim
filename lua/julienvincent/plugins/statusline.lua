return {
  {
    "nvim-lualine/lualine.nvim",

    event = "VeryLazy",

    config = function()
      local lualine = require("lualine")

      local function get_lsp_client_status()
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          if client.initialized then
            return ""
          else
            return ""
          end
        end
        return ""
      end

      local function get_nrepl_status()
        if vim.bo.filetype == "clojure" then
          local nrepl = require("julienvincent.lang.clojure.nrepl")
          return nrepl.get_repl_status("Not Connected")
        end
        return ""
      end

      lualine.setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = "auto",
        },
        sections = {
         lualine_a = {
            "mode",
          },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_c = {
            { path = 1, "filename" },
          },

          lualine_x = {
            {
              "lsp_client_status",
              fmt = get_lsp_client_status,
              color = {
                fg = "#b0b846"
              }
            }
          },
          lualine_y = {
            {
              fmt = get_nrepl_status,
              "repl_status",
            },
          },
          lualine_z = {
            "filetype"
          },
        },
      })
    end
  },
}
