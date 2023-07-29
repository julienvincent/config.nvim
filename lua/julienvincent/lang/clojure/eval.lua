local M = {}

function M.eval(ns, code, opts)
  opts = opts or {}

  local client = require("conjure.client")
  local fn = require("conjure.eval")["eval-str"]

  client["with-filetype"](
    "clojure",
    fn,
    vim.tbl_extend("force", {
      origin = "julienvincent.lang.clojure.eval",
      context = ns,
      code = code,
    }, opts)
  )
end

return M
