local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

autocmd("FileType", {
  pattern = { "*" },
  group = general,
  desc = "Override some buffer local options",
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")

    -- This prevents comments from being inserted when in normal mode and pressing `o` or `O`
    vim.opt.formatoptions:remove("o")
    vim.opt.formatoptions:append("r")
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
    vim.opt_local.linebreak = true
    vim.opt_local.shiftwidth = 2
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
