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
    "easymotion/vim-easymotion",
    event = "VeryLazy",
    init = function()
      vim.g["EasyMotion_do_mapping"] = false
      vim.g["EasyMotion_smartcase"] = true
    end,
    config = function()
      local map = require("julienvincent.helpers.keys").map
      map("n", "f", "<Plug>(easymotion-s)", "EasyMotion")
      map("v", "f", "<Plug>(easymotion-s)", "EasyMotion")

      map("n", "s", "<Plug>(easymotion-s2)", "EasyMotion")
      map("v", "s", "<Plug>(easymotion-s2)", "EasyMotion")

      map("n", "F", "<Plug>(easymotion-overwin-f)", "EasyMotion Global")
    end,
  },

  {
    "svermeulen/vim-easyclip",
    event = "VeryLazy",
    init = function()
      vim.g["EasyClipShareYanks"] = true
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

  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
}
