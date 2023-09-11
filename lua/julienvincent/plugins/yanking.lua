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

      -- local autocmd = vim.api.nvim_create_autocmd
      -- local group = vim.api.nvim_create_augroup("YankPersistence", { clear = true })
      --
      -- autocmd("TextYankPost", {
      --   pattern = "*",
      --   group = group,
      --   desc = "Write shada file on yank",
      --   callback = function()
      --     local timer = vim.loop.new_timer()
      --     timer:start(
      --       50,
      --       0,
      --       vim.schedule_wrap(function()
      --         timer:close()
      --         vim.cmd("wshada")
      --       end)
      --     )
      --   end,
      -- })
      --
      -- autocmd("FocusGained", {
      --   pattern = "*",
      --   group = group,
      --   desc = "Sync shada file",
      --   callback = function()
      --     local timer = vim.loop.new_timer()
      --     timer:start(
      --       100,
      --       0,
      --       vim.schedule_wrap(function()
      --         timer:close()
      --         vim.cmd("rshada")
      --       end)
      --     )
      --   end,
      -- })
    end,
  },
}
