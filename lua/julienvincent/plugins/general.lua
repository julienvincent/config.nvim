return {
  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
    opts = {
      keymaps = {
        visual = "gS",
        visual_line = "gS",
      },
    },
  },

  {
    "psliwka/vim-smoothie",
    event = "BufReadPost",
    init = function()
      vim.g["smoothie_remapped_commands"] = { "<C-D>", "<C-U>" }
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      require("Comment").setup({})
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    config = function()
      require("scrollbar").setup({
        handle = {
          blend = 0,
        },
        marks = {
          Cursor = {
            text = "",
          },
        },
        handlers = {
          gitsigns = true,
        },
        hide_if_all_visible = true,
        excluded_buftypes = {
          "nofile",
        },
        excluded_filetypes = {
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "neo-tree",
          "neo-tree-popup",
          "DiffviewFiles",
        },
      })
    end,
  },

  {
    "phaazon/hop.nvim",
    event = "BufReadPost",
    branch = "v2",
    config = function()
      local directions = require("hop.hint").HintDirection
      local hop = require("hop")

      hop.setup({})

      vim.keymap.set({ "n", "v" }, "s", hop.hint_char1, { desc = "Hop" })
      vim.keymap.set("n", "S", function()
        hop.hint_char1({ multi_windows = true })
      end, { desc = "Hop all windows" })

      vim.keymap.set({ "n", "v" }, "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { desc = "Hop Line" })
      vim.keymap.set({ "n", "v" }, "F", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { desc = "Hop Line" })
    end,
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        input = {
          insert_only = false,
          start_in_insert = true,

          win_options = {
            -- Window transparency (0-100)
            winblend = 0,
          },

          get_config = function(opts)
            if opts.kind == "center" then
              return {
                relative = "editor",
              }
            end
          end,
        },
      })
    end,
  },

  {
    "NoahTheDuke/vim-just",
    ft = "just",
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g["mkdp_auto_close"] = 0
    end,
  },

  { "echasnovski/mini.bufremove", event = "BufReadPost" },

  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
}
