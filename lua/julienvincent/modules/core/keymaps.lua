local M = {}

M.setup = function()
  local saving = require("julienvincent.modules.core.auto-save")
  local lazy = require("lazy")

  local map = vim.keymap.set

  map("n", "<leader>qq", function()
    saving.write_all_buffers()
    vim.api.nvim_command("qa")
  end, { desc = "Save and quit" })

  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

  -- tabs
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

  vim.api.nvim_set_keymap("n", "<S-Down>", "<Nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<S-Up>", "<Nop>", { noremap = true, silent = true })

  map("n", "<leader>LL", lazy.show, { desc = "Show Lazy" })

  map("v", "<localleader>s", '"zy:%s/<C-r>z//g<Left><Left>', {
    noremap = true,
    desc = "Replace selection",
  })

  map("n", "gx", function()
    local uri = vim.fn.expand("<cfile>")
    vim.fn.jobstart({ "open", uri }, {
      detach = true,
    })
  end, {
    noremap = true,
    desc = "Open URI under cursor",
  })

  map("n", "yc", "yy<cmd>normal gcc<CR>p", {
    desc = "Duplicate line below, commenting first",
  })
end

return M
