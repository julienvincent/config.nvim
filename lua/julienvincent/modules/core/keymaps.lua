local map = require("julienvincent.helpers.keys").map
local saving = require("julienvincent.modules.core.auto-save")

local M = {}

M.setup = function()
  map("n", "<leader>qq", function()
    saving.write_all_buffers()
    vim.api.nvim_command("qa")
  end, "Save and quit")

  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", "Escape and clear hlsearch")

  map("n", "<leader>u", vim.cmd.UndotreeToggle, "Toggle UndoTree")

  map("n", "<localleader>d", vim.diagnostic.open_float, "Show diagnostics at cursor")

  -- tabs
  map("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", "Next Tab")
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close Tab")
  map("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", "Previous Tab")

  vim.api.nvim_set_keymap("n", "<S-Down>", "<Nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<S-Up>", "<Nop>", { noremap = true, silent = true })

  map("n", "<leader>LL", require("lazy").show, "Show Lazy")
end

return M
