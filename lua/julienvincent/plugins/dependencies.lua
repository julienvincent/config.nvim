return {
  { "MunifTanjim/nui.nvim", lazy = true },
  { "echasnovski/mini.icons", lazy = true },
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
  { "nvim-neotest/nvim-nio", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "kkharji/sqlite.lua", lazy = true },
}
