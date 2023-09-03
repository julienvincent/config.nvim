local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

autocmd("FileType", {
  pattern = { "*" },
  group = general,
  desc = "Override the definition of a keyword",
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable spellcheck for certain filetypes",
  group = general,
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable line wrapping for certain filetypes",
  group = general,
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
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
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = { "*" },
  callback = function()
    require("julienvincent.core.highlights").setup_highlights()
  end,
})
