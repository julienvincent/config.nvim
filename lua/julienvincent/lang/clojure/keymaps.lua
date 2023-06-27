local function eval_str(code)
  local eval = require("conjure.eval")
  local client = require("conjure.client")
  client["with-filetype"]("clojure", eval["eval-str"], {
    origin = "julienvincent.custom-command",
    code = code,
  })
end

return {
  {
    "<leader>§",
    function()
      eval_str("(do (ns user) (reset) nil)")
    end,
    desc = "user/reset",
  },
  {
    "<leader>po",
    function()
      eval_str("(do (ns user) (require '[portal.api :as p]) (add-tap #'p/submit) (p/open) nil)")
    end,
    desc = "Open portal",
  },
  {
    "<leader>*",
    function()
      eval_str("(do (require '[clojure.pprint :as pprint]) (pprint/pprint *e))")
    end,
    desc = "Eval last error",
  },
}
