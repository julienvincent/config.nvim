local function eval_str(ns, code)
  local client = require("conjure.client")

  -- Conjure recommends using `conjure.eval["eval-str"]` but that wrapping function doesn't
  -- allow specifying or overriding the `context` opt.
  --
  -- This opt field is used to eval `(ns context)` prior to evaling the given code. By default
  -- the `context` field is derived from the active buffers `(ns ..)` directive which is _not_
  -- correct for these global commands.
  --
  -- We therefore use the underlying eval-str implementation which allows passing context
  -- explicitly. This means whatever the recommended wrapper fn is doing, we are not. Might
  -- cause issues.
  local fn = require("conjure.client.clojure.nrepl.action")["eval-str"]

  client["with-filetype"]("clojure", fn, {
    origin = "julienvincent.custom-command",
    context = ns,
    code = code,
  })
end

return {
  {
    "<leader>§",
    function()
      eval_str("user", "(do (tap> (reset)))")
    end,
    desc = "user/reset",
  },
  {
    "<leader>po",
    function()
      eval_str("user", "(do (require '[portal.api :as p]) (add-tap #'p/submit) (p/open) nil)")
    end,
    desc = "Open portal",
  },
  {
    "<leader>*",
    function()
      eval_str("user", "(do (require '[clojure.pprint :as pprint]) (pprint/pprint *e) (tap> *e))")
    end,
    desc = "Eval last error",
  },
}
