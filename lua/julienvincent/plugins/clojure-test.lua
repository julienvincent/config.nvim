return {
  {
    dir = "~/code/clojure-test.nvim",
    config = function()
      require("clojure-test").setup({
        keys = {
          ui = {
            collapse_node = { "<Left>", "h" },
            expand_node = { "<Right>", "l" },
          },
        },
        hooks = {
          before_run = function()
            local saving = require("julienvincent.modules.core.auto-save")
            local eval = require("julienvincent.lang.clojure.eval").eval

            saving.write_all_buffers()
            eval("user", "(reload-namespaces)")
          end,
        },
      })
    end,
    dependencies = {
      { "nvim-neotest/nvim-nio" },
      { "MunifTanjim/nui.nvim" },
    },
  },
}
