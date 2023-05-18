return {
  {
    "<leader>§",
    function()
      local eval = require("conjure.eval")
      eval["eval-str"]({
        code = "(do (ns user) (reset) nil)",
        origin = "custom_command",
      })
    end,
    desc = "user/reset",
  },
  {
    "<leader>po",
    function()
      local eval = require("conjure.eval")
      eval["eval-str"]({
        code = "(do (ns user) (open-portal!) nil)",
        origin = "custom_command",
      })
    end,
    desc = "Open portal",
  },
  {
    "<leader>*",
    function()
      local eval = require("conjure.eval")
      eval["eval-str"]({
        code = "(do (require '[clojure.pprint :as pprint]) (pprint/pprint *e))",
        origin = "custom_command",
      })
    end,
    desc = "Eval last error",
  },
}
