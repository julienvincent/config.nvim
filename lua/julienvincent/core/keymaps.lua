local map = require("julienvincent.helpers.keys").map

map("n", "<leader>qq", "<cmd>qa<cr>", "Quit NeoVim")

map("n", "<leader>W", "<cmd>wa<cr>", "Save all buffers")

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Yank to system clipboard
map("v", "<leader>y", [["+y]], "Copy to system clipboard")
map("n", "<leader>yy", [["+yy]], "Copy line under cursor to system clipboard")

map("n", "<leader>u", function()
  vim.cmd.UndotreeToggle()
  vim.cmd.UndotreeFocus()
end, "Toggle UndoTree")

-- These don't work yet
map("n", ">)", "<Plug>(sexp_emit_tail_element)")
map("n", "<)", "<Plug>(sexp_capture_next_element)")
map("n", ">(", "<Plug>(sexp_emit_head_element)")
map("n", "<(", "<Plug>(sexp_capture_previous_element)")

---- Move to window using <ctrl>-hjkl
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
---- Move to window using <ctrl>-<ArrowKey>
map("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-Down>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-Up>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", function()
  vim.api.nvim_feedkeys(":tabnew ~/code/", "n", false)
end, { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
