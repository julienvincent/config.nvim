return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override_by_extension = {
          ["num"] = {
            icon = "",
            color = "#A2AAAD",
            name = "Numscript",
          },
        },
      })
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "kkharji/sqlite.lua", lazy = true },
}
