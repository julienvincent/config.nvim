return {
  {
    "stevearc/quicker.nvim",
    ft = { "qf" },
    config = function()
      require("quicker").setup({})
    end,
  },
}
