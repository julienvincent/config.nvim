return {
  {
    "julienvincent/clojure-test.nvim",
    config = function()
      local clojure_test = require("clojure-test")
      local api = require("clojure-test.api")

      clojure_test.setup({
        layout = {
          style = "float",
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

      vim.keymap.set("n", "<localleader>ta", api.run_all_tests, { desc = "Run all tests" })
      vim.keymap.set("n", "<localleader>tr", api.run_tests, { desc = "Run tests" })
      vim.keymap.set("n", "<localleader>tn", api.run_tests_in_ns, { desc = "Run tests in a namespace" })
      vim.keymap.set("n", "<localleader>tp", api.rerun_previous, { desc = "Rerun the most recently run tests" })
      vim.keymap.set(
        "n",
        "<localleader>tl",
        api.run_tests_in_ns,
        { desc = "Find and load test namespaces in classpath" }
      )
    end,
  },
}
