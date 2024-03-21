return {
  {
    "rest-nvim/rest.nvim",
    version = "1.x",
    ft = "http",
    config = function()
      require("rest-nvim").setup({
        highlight = {
          enabled = false,
        },
      })
    end,
  },
}
