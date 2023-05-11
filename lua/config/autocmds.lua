vim.cmd([[
  augroup autosave_on_focus_lost
    autocmd!
    autocmd FocusLost,BufHidden * silent! if &modified && !empty(bufname('%')) | write | endif
  augroup END
]])

-- This is a hack to change the cwd to the currently open project folder
vim.cmd([[
  augroup set_cwd_to_opened_directory
    autocmd!
    autocmd VimEnter * if isdirectory(expand("%")) | execute "cd " . expand("%:p") | endif
  augroup END
]])

-- Define a custom highlight group for non-bold functions
vim.cmd([[highlight! NonBoldFunction gui=none]])
-- Link the Treesitter function group to the custom highlight group
vim.cmd([[highlight! link TSFunction NonBoldFunction]])

-- vim.cmd([[highlight! GruvboxGreenBold guifg=#b8bb26]])
