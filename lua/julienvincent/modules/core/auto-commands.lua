local M = {}

M.setup = function()
  local general = vim.api.nvim_create_augroup("General", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Override the iskeyword opt for some languages",
    group = general,
    pattern = { "clojure" },
    callback = function()
      vim.opt_local.iskeyword = "@,48-57,_,192-255,!,?"
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    desc = "Override buffer-local settings for all filetypes",
    group = general,
    pattern = { "*" },
    callback = function()
      -- This prevents comments from being inserted when in normal mode and pressing `o` or `O`
      vim.opt.formatoptions:remove("o")
      vim.opt.formatoptions:append("r")
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
