vim.cmd([[
  augroup autosave_on_focus_lost
    autocmd!
    autocmd FocusLost * silent! if &modified && !empty(bufname('%')) | write | endif
  augroup END
]])

-- This is a hack to change the cwd to the currently open project folder
vim.cmd([[
  augroup set_cwd_to_opened_directory
    autocmd!
    autocmd VimEnter * if isdirectory(expand("%")) | execute "cd " . expand("%:p") | endif
  augroup END
]])

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() end,
})

local autocmd = vim.api.nvim_create_autocmd
autocmd("FileType", {
  pattern = {
    "clojure",
  },
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")
  end,
})

-- Define a custom highlight group for non-bold functions
vim.cmd([[highlight! NonBoldFunction gui=none]])
-- Link the Treesitter function group to the custom highlight group
vim.cmd([[highlight! link TSFunction NonBoldFunction]])

-- vim.cmd([[highlight! GruvboxGreenBold guifg=#b8bb26]])
