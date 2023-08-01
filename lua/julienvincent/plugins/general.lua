return {
  {
    "thallada/gruvbox.nvim",
    enabled = false,
    lazy = true,
    config = function()
      require("gruvbox").setup({
        contrast = "soft",
        undercurl = false,
        underline = false,
        bold = false,
        italic = {
          strings = false,
          comments = false,
          operators = false,
          folds = false,
        },
      })
    end,
  },

  {
    "sainnhe/gruvbox-material",
    lazy = true,
    init = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "soft"
    end,
  },

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
    "windwp/nvim-autopairs",
    event = "BufReadPost",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        enable_check_bracket_line = false,
      })
    end,
  },

  {
    "mbbill/undotree",
    event = "VeryLazy",
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
    event = "VeryLazy",
    config = function()
      require("Comment").setup({})
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Spectre find and replace",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      { "<localleader>D", "<cmd>Trouble<cr>", desc = "Open Trouble Diagnostics" },
    },
    opts = {
      use_diagnostic_signs = true,
      mode = "document_diagnostics",
    },
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
        excluded_filetypes = {
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
          "neo-tree",
          "neo-tree-popup",
          "DiffviewFiles",
        },
      })
    end,
  },

  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    branch = "v2",
    config = function()
      local map = require("julienvincent.helpers.keys").map

      local directions = require("hop.hint").HintDirection
      local hop = require("hop")

      hop.setup({})

      map({ "n", "v" }, "s", hop.hint_char1, "Hop")
      map("n", "S", function()
        hop.hint_char1({ multi_windows = true })
      end, "Hop all windows")

      map({ "n", "v" }, "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, "Hop Line")
      map({ "n", "v" }, "F", function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, "Hop Line")
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
    "svermeulen/vim-easyclip",
    event = "VeryLazy",
    init = function()
      vim.g["EasyClipShareYanks"] = true

      vim.g["EasyClipUseCutDefaults"] = false
      vim.g["EasyClipEnableBlackHoleRedirect"] = false
      vim.g["EasyClipUsePasteToggleDefaults"] = false
    end,
    config = function()
      local map = require("julienvincent.helpers.keys").map
      map("n", "<c-p>", "<Plug>EasyClipSwapPasteBackwards<CR>")
      map("n", "<c-s-p>", "<Plug>EasyClipSwapPasteForward<CR>")
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
  },

  { "echasnovski/mini.bufremove", event = "VeryLazy" },

  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
}
