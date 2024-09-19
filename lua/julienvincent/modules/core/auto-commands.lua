local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local M = {}

M.setup = function()
  local general = augroup("General", { clear = true })

  autocmd("FileType", {
    pattern = { "clojure" },
    group = general,
    desc = "Override the iskeyword opt for some languages",
    callback = function()
      vim.opt_local.iskeyword = "@,48-57,_,192-255,!,?"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable line wrapping for certain filetypes",
    group = general,
    pattern = { "markdown", "mdx" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
      vim.opt_local.shiftwidth = 2

      vim.opt_local.textwidth = 120
      vim.opt.formatoptions:append("t")
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Fix shiftwidth for all filetypes",
    group = general,
    pattern = { "*" },
    callback = function()
      vim.opt_local.shiftwidth = 2
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Close certain filetypes with <q>",
    group = general,
    pattern = {
      "help",
      "lspinfo",
      "man",
      "spectre_panel",
      "tsplayground",
      "HttpResult",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
  })
end

return M
