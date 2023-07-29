return {
  {
    "anuvyklack/hydra.nvim",
    event = "VeryLazy",
    config = function()
      require("julienvincent.hydras.window").create()
      require("julienvincent.hydras.portal").create()
    end,
  },
}
