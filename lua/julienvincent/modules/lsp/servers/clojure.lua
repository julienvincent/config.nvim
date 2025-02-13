local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")
local api = require("julienvincent.modules.lsp.api")

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

local root_dir_fn = fs.find_furthest_root({
  { "deps.edn", is_root = contains_kmono_project },
  "bb.edn",
  "project.clj",
  "shadow-cljs.edn",
})

-- When `gd`ing to a function in a dependency we don't want to start an LSP
-- server for that dependency. Instead we want to use the LSP server of the
-- buffer that we just came from.
--
-- There isn't really an easy way to determine that so instead we just look for
-- existing clojure-lsp servers and use the root_dir of the first one found.
--
-- This is a close enough aproximation, but ideally this is iterated on by
-- finding a way to determine the exact lsp client to use.
local function dependency_root_dir_fn(path)
  local prefix = string.sub(path, 1, 10)
  if prefix == "zipfile://" then
    for _, client in ipairs(api.get_clients()) do
      if client.name == "clojure-lsp" then
        return client.root_dir
      end
    end
  end

  return root_dir_fn(path)
end

return {
  name = "clojure-lsp",
  filetypes = { "clojure", "edn" },

  cmd = mason.command("clojure-lsp"),
  root_dir = dependency_root_dir_fn,

  single_file_support = true,
  init_options = {
    ["project-specs"] = {
      {
        ["project-path"] = "deps.edn",
        ["classpath-cmd"] = { "kmono", "cp" },
      },
    },

    hover = {
      ["hide-file-location?"] = true,
      ["hide-signature-call?"] = true,
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
