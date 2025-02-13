local M = {}

M.setup = function()
  local lazy = require("lazy")

  vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", {
    desc = "Escape and clear hlsearch",
  })

  -- I use <Tab> to open my buffer switcher, but in terminals <C-i> and <Tab>
  -- map to the same ascii codes (why the fuck?).
  --
  -- To get around this I am mapping <M-i> to do the same thing as <C-i>. If
  -- this is paired with a terminal emulator that can remap <C-i> to <M-i> then
  -- I can use both <Tab> and <C-i> to do distinct things.
  --
  -- TL;DR This indirectly allows me to use <C-i> to do what <C-i> is supposed
  -- to do (jump-list backwards) and <Tab> to open my buffer switcher.
  vim.keymap.set({ "n", "i", "v" }, "<M-i>", "<C-i>", { noremap = true, silent = true })

  -- tabs
  vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Next Tab" })
  vim.keymap.set("n", "<leader><tab><Right>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  vim.keymap.set("n", "<leader><tab><Left>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

  vim.keymap.set("n", "<S-Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set("n", "<S-Up>", "<Nop>", { noremap = true, silent = true })

  vim.keymap.set("n", "<leader>LL", lazy.show, { desc = "Show Lazy" })

  vim.keymap.set("v", "<localleader>s", [["zy:%s/<C-r>=escape(@z, '\/.')<CR>//g<Left><Left>]], {
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
