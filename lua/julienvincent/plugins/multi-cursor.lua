return {
  {
    "brenton-leighton/multiple-cursors.nvim",
    event = "VeryLazy",
    enabled = false,
    config = true,
    keys = {
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" } },
      { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>" },
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" } },
      { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>" },
      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
    },
  },
}
