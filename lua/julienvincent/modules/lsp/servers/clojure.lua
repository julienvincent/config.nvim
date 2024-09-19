local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function contains_kmono_project(path)
  local file_path = path .. "/deps.edn"
  local file = io.open(file_path, "r")
  if not file then
    return false
  end

  local content = file:read("*all")
  file:close()

  if string.find(content, "kmono/workspace") then
    return true
  else
    return false
  end
end

return {
  name = "clojure-lsp",
  filetypes = { "clojure", "edn" },

  cmd = mason.command("clojure-lsp"),
  root_dir = fs.find_furthest_root({
    { "deps.edn", is_root = contains_kmono_project },
    "bb.edn",
    "project.clj",
    "shadow-cljs.edn",
  }),

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
      local saving = require("julienvincent.modules.core.auto-save")

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
        saving.write_all_buffers()
        return
      end

      vim.lsp.handlers["textDocument/rename"](...)
      saving.write_all_buffers()
    end,
  },

  before_init = function(params)
    params.workDoneToken = "enable-progress"
  end,
}
