return {
  {
    "echasnovski/mini.surround",
    event = "BufReadPost",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",

          find = "",
          find_left = "",
          highlight = "",
          update_n_lines = "",
        },
        custom_surroundings = {
          -- This is a modification of the original source taken from here:
          -- https://github.com/echasnovski/mini.surround/blob/0e67c4bc147f2a15cee94e7c94dcc0e115b9f55e/lua/mini/surround.lua#L1076
          --
          -- This simply swaps the brackets - for example the `(` keybinding becomes `)`. I do this because I prefer pressing
          -- `(` and I don't want empty spaces added when I do that.
          [")"] = { input = { "%b()", "^.%s*().-()%s*.$" }, output = { left = "( ", right = " )" } },
          ["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
          ["]"] = { input = { "%b[]", "^.%s*().-()%s*.$" }, output = { left = "[ ", right = " ]" } },
          ["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
          ["}"] = { input = { "%b{}", "^.%s*().-()%s*.$" }, output = { left = "{ ", right = " }" } },
          ["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
          [">"] = { input = { "%b<>", "^.%s*().-()%s*.$" }, output = { left = "< ", right = " >" } },
          ["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
        },
      })

      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "gs", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    end,
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
      local wk = require("which-key")

      wk.setup({
        delay = 1000,
      })

      vim.keymap.set("n", "<localleader>?", function()
        wk.show({ global = false })
      end, {
        desc = "Buffer Local Keymaps (which-key)",
      })

      vim.keymap.set("n", "<leader>?", function()
        wk.show({ global = true })
      end, {
        desc = "Buffer Local Keymaps (which-key)",
      })
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
    -- The original plugin (https://github.com/hadronized/hop.nvim) is now unmaintained. The plugin below
    -- is a fork that seems to be more actively maintained.
    "smoka7/hop.nvim",
    event = "BufReadPost",
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
        select = {
          fzf_lua = {
            previewer = false,
            winopts = {
              preview = {
                hidden = "hidden",
              },
              height = 10,
              width = 0.33,
            },
          },
        },
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
}
