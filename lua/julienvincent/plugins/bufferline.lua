return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "tabs",
        themable = true,
        separator_style = "thin",
        always_show_bufferline = false,
      },
    },
  },
}
