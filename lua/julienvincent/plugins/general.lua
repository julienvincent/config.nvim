return {
  {
    "thallada/gruvbox.nvim",
    lazy = true,
    config = function()
      local colors = require("gruvbox.palette").colors

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
        -- overrides = {
        --   DiffviewDiffAddAsDelete = { bg = "#431313" },
        --   DiffDelete = { bg = "none", fg = colors.dark2 },
        --   DiffviewDiffDelete = { bg = "none", fg = colors.dark2 },
        --   DiffAdd = { bg = "#142a03" },
        --   DiffChange = { bg = "#3B3307" },
        --   DiffText = { bg = "#4D520D" },
        -- }
      })
    end
  },

  {
    "sainnhe/gruvbox-material",
    init = function()
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_background = "soft"
    end
  },

  {
    "kylechui/nvim-surround",
    event = "BufReadPost",
  },
  {
    "windwp/nvim-autopairs",
    event = "BufReadPost",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  { "mbbill/undotree" },
  { "psliwka/vim-smoothie" },
  { "folke/which-key.nvim" },
  { "numToStr/Comment.nvim", config = true },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",

    opts = {
      render = "compact",
      stages = "static",
    },
  },

  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "MunifTanjim/nui.nvim" },
}
