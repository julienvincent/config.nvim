return {
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    config = function()
      require("snacks").setup({
        image = {
          enabled = true,
          doc = {
            enabled = true,
            inline = false,
            float = false,
          },
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

      local image = require("snacks.image")
      vim.keymap.set("n", "<localleader>i", function()
        image.hover()
      end, { silent = true, desc = "Preview image" })

      vim.keymap.set("n", "<localleader>I", function()
        image.doc.hover_close()
      end, {
        desc = "Clear image",
      })
    end,
  },
}
