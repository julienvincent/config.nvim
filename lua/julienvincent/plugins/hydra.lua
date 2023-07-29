return {
  {
    "anuvyklack/hydra.nvim",
    event = "VeryLazy",
    config = function()
      require("julienvincent.hydras.window").create()
    end,
  },
}
