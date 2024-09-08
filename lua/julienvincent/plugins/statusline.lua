local function get_lsp_client_status()
  return "LSP"
end

local function get_lsp_cond()
  local client = vim.lsp.get_active_clients({ bufnr = 0 })[1]
  if client then
    return true
  end
  return false
end

local function get_lsp_client_color()
  local client = vim.lsp.get_active_clients({ bufnr = 0 })[1]
  if not client or not client.initialized then
    return {
      bg = "#928374",
      fg = "#1b1b1b",
    }
  end

  return {
    bg = "#b0b846",
    fg = "#1b1b1b",
  }
end

local function get_nrepl_status()
  if vim.bo.filetype ~= "clojure" then
    return ""
  end

  local nrepl = require("julienvincent.modules.clojure.nrepl.api")
  return nrepl.get_repl_status("Not Connected")
end

local function show_recording()
  local reg = vim.fn.reg_recording()

  if reg == "" then
    return ""
  end

  return "RECORDING @" .. reg
end

return {
  {
    "nvim-lualine/lualine.nvim",

    event = "VeryLazy",

    config = function()
      local lualine = require("lualine")

      lualine.setup({
        options = {
          icons_enabled = true,
          globalstatus = true,
          theme = "auto",
        },
        sections = {
          lualine_a = {
            "mode",
            { show_recording, color = { bg = "#d79921" } },
          },
          lualine_b = {
            "branch",
            "diff",
            "diagnostics",
          },
          lualine_c = {
            {
              path = 1,
              "filename",

              -- Small attempt to workaround https://github.com/nvim-lualine/lualine.nvim/issues/872
              -- Upstream issue: https://github.com/neovim/neovim/issues/19464
              fmt = function(filename)
                if #filename > 80 then
                  filename = vim.fs.basename(filename)
                end
                return filename
              end,
            },
          },

          lualine_x = {
            {
              get_lsp_client_status,
              cond = get_lsp_cond,
              color = get_lsp_client_color,
              separator = { left = "" },
            },
          },
          lualine_y = {
            {
              get_nrepl_status,
            },
          },
          lualine_z = {
            "filetype",
          },
        },
      })
    end,
  },
}
