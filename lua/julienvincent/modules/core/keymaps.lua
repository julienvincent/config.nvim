local M = {}

M.setup = function()
  local saving = require("julienvincent.modules.core.auto-save")
  local lazy = require("lazy")

  vim.keymap.set("n", "<leader>qq", function()
    saving.write_all_buffers()
    vim.api.nvim_command("qa")
  end, { desc = "Save and quit" })

  vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", {
    desc = "Escape and clear hlsearch",
  })

  -- tabs
  vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Next Tab" })
  vim.keymap.set("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  vim.keymap.set("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

  vim.keymap.set("n", "<S-Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set("n", "<S-Up>", "<Nop>", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>LL", lazy.show, { desc = "Show Lazy" })

  vim.keymap.set("v", "<localleader>s", '"zy:%s/<C-r>z//g<Left><Left>', {
    noremap = true,
    desc = "Replace selection",
  })

  vim.keymap.set("n", "gx", function()
    local uri = vim.fn.expand("<cfile>")
    vim.fn.jobstart({ "open", uri }, {
      detach = true,
    })
  end, {
    noremap = true,
    desc = "Open URI under cursor",
  })

  vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", {
    desc = "Duplicate line below, commenting first",
  })
end

return M
