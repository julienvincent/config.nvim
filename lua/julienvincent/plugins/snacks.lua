return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    config = function()
      vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", {
        link = "CursorLine",
      })

      vim.api.nvim_set_hl(0, "SnacksInputBorder", {
        link = "Yellow",
      })

      vim.api.nvim_set_hl(0, "SnacksInputTitle", {
        link = "Orange",
      })

      require("snacks").setup({
        image = {
          enabled = true
        },

        input = {
          enabled = true,
          win = {
            relative = "cursor",
            row = -3,
            title_pos = "left",
          },
        },

        picker = {
          enabled = true,
          prompt = "❯ ",
          sources = {
            select = {
              config = function(opts)
                opts.layout.layout.width = 0.33
                opts.layout.layout.min_width = 20

                opts.win.input.keys["<Esc>"] = { "close", mode = { "n", "i" } }
              end,
            },
          },
        },
      })
    end,
  },
}
