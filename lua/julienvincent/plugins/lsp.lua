return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    lazy = true,
    config = function()
      require("mason").setup({
        ui = { border = "rounded" },
        PATH = "skip",
      })
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },

  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  {
    "j-hui/fidget.nvim",
    event = "BufReadPre",
    config = function()
      require("fidget").setup({
        progress = {
          lsp = {
            progress_ringbuf_size = 1024,
          },
        },
      })
    end,
  },

  {
    "ldelossa/litee.nvim",
    lazy = true,
    config = function()
      require("litee.lib").setup({
        notify = {
          enabled = false,
        },
        panel = {
          orientation = "bottom",
          panel_size = 10,
        },
      })

      local panel = require("litee.lib.panel")
      vim.keymap.set("n", "<leader>ltt", panel.toggle_panel, { desc = "Toggle calltree panel" })
    end,
  },

  {
    "ldelossa/litee-calltree.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
    event = "VeryLazy",
    opts = {},
    config = function()
      require("litee.calltree").setup({
        on_open = "panel",
        map_resize_keys = false,

        keymaps = {
          expand = "<Right>",
          collapse = "<Left>",
        },
      })
    end,
  },
}
