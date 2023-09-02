local map = require("julienvincent.helpers.keys").map
local saving = require("julienvincent.behaviours.auto-save")

map("n", "<leader>qq", function()
  saving.write_all_buffers()
  vim.api.nvim_command("qa")
end, "Save and quit")

map("n", "<leader>W", saving.write_all_buffers, "Save all buffers")

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", "Escape and clear hlsearch")

map("n", "<C-Tab>", "<C-^>", "Toggle previous buffer")

map("n", "<leader>u", vim.cmd.UndotreeToggle, "Toggle UndoTree")

---- Move to window using <ctrl>-hjkl
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")
---- Move to window using <ctrl>-<ArrowKey>
map("n", "<C-Left>", "<C-w>h", "Go to left window")
map("n", "<C-Down>", "<C-w>j", "Go to lower window")
map("n", "<C-Up>", "<C-w>k", "Go to upper window")
map("n", "<C-Right>", "<C-w>l", "Go to right window")

map("n", "<localleader>d", vim.diagnostic.open_float, "Show diagnostics at cursor")

-- tabs
map("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", "Next Tab")
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
map("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", "Previous Tab")
