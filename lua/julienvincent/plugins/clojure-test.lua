return {
  {
    "julienvincent/clojure-test.nvim",
    ft = { "clojure" },
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
            local nrepl = require("julienvincent.modules.clojure.nrepl.api")

            saving.write_all_buffers()
            nrepl.eval("jv.repl", "(reload-namespaces)")
          end,
        },
      })

      vim.keymap.set("n", "<localleader>tl", api.load_tests, { desc = "Find and load test namespaces in classpath" })
      vim.keymap.set("n", "<localleader>ta", api.run_all_tests, { desc = "Run all tests" })
      vim.keymap.set("n", "<localleader>tr", api.run_tests, { desc = "Run tests" })
      vim.keymap.set("n", "<localleader>tn", api.run_tests_in_ns, { desc = "Run tests in a namespace" })
      vim.keymap.set("n", "<localleader>tp", api.rerun_previous, { desc = "Rerun the most recently run tests" })
      vim.keymap.set("n", "<localleader>tf", api.rerun_failed, { desc = "Rerun failed tests from the previous run" })
      vim.keymap.set("n", "<localleader>to", api.open_last_report, { desc = "Re-open the previous report" })

      vim.keymap.set("n", "<localleader>!", function()
        api.analyze_exception("*e")
      end, { desc = "Inspect the most recent exception" })
    end,
  },
}
