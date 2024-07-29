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

  handlers = {
    ["textDocument/rename"] = function(...)
      local _, rename_data = ...
      local doc_changes = rename_data.documentChanges[1]
      if doc_changes and doc_changes.kind == "rename" then
        local data = {
          old_name = vim.uri_to_fname(doc_changes.oldUri),
          new_name = vim.uri_to_fname(doc_changes.newUri),
        }
        require("lsp-file-operations.will-rename").callback(data)
        vim.lsp.handlers["textDocument/rename"](...)
        require("lsp-file-operations.did-rename").callback(data)
        return
      end

      vim.lsp.handlers["textDocument/rename"](...)
    end,
  },

  before_init = function(params)
    params.workDoneToken = "enable-progress"
  end,
}
