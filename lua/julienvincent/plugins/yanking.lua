return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    event = "BufReadPost",
    config = function()
      require("yanky").setup({
        ring = {
          storage = "sqlite"
        },
        system_clipboard = {
          sync_with_ring = false,
        },
        highlight = {
          on_put = false,
          on_yank = false,
        },
        preserve_cursor_position = {
          enabled = false,
        },
      })

      vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
      vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
      vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after" })
      vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before" })

      vim.keymap.set("n", "[p", "<Plug>(YankyCycleForward)", {
        desc = "Cycle paste backwards",
      })
      vim.keymap.set("n", "]p", "<Plug>(YankyCycleBackward)", {
        desc = "Cycle paste forwards",
      })

      vim.keymap.set("n", "<localleader>p", "<Cmd>YankyRingHistory<Cr>", {
        desc = "Yank history picker",
      })
    end,
  },
}
