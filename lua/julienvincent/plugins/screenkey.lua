return {
  {
    "NStefan002/screenkey.nvim",
    cmd = { "Screenkey" },
    config = function()
      require("screenkey").setup({
        clear_after = 10,
      })
    end,
  },
}
