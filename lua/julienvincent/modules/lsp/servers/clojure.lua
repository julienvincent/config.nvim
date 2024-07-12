local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "clojure-lsp",
  filetypes = { "clojure", "edn" },

  cmd = mason.command("clojure-lsp"),
  root_dir = fs.find_furthest_root({
    "deps.edn",
    "bb.edn",
    "project.clj",
    "shadow-cljs.edn",
  }, fs.fallback_fn_tmp_dir),

  single_file_support = true,
  init_options = {
    ["project-specs"] = {
      {
        ["project-path"] = "deps.edn",
        ["classpath-cmd"] = { "kmono", "cp" },
      },
    },
  },

  before_init = function(params)
    params.workDoneToken = "enable-progress"
  end,
}
