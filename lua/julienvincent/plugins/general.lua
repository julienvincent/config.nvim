return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      contrast = "soft",
    },
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
  { "numToStr/Comment.nvim" },

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
