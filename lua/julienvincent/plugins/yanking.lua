return {
  {
    "gbprod/yanky.nvim",
    event = "BufReadPost",
    config = function()
      local yanky = require("yanky")
      yanky.setup({
        ring = {
          storage = "sqlite",
          update_register_on_cycle = true,
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

      local yank_entry = yanky.history.storage.get(2)
      if yank_entry.regcontents then
        vim.fn.setreg('"', yank_entry.regcontents)
        vim.fn.setreg("0", yank_entry.regcontents)
      end

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
