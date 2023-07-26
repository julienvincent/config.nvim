local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

autocmd("FocusGained", {
  pattern = "*",
  group = general,
  desc = "Refresh NeoTree git status on focus",
  callback = function()
    if package.loaded["neo-tree.sources.git_status"] then
      require("neo-tree.sources.git_status").refresh()
    end
  end,
})

autocmd("FileType", {
  pattern = { "*" },
  group = general,
  desc = "Override the definition of a keyword",
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.zed" },
  group = general,
  desc = "Set the filetype of .zed files",
  callback = function(event)
    vim.api.nvim_buf_set_option(event.buf, "filetype", "authzed")
    vim.bo.commentstring = "//%s"
  end,
})

autocmd("BufNewFile", {
  pattern = "conjure-log-*",
  group = general,
  desc = "Disable diagnostics in conjure log buffer",
  callback = function(event)
    vim.diagnostic.disable(event.buf)
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
