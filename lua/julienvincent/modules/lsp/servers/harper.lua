local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function db_path(subpath)
  local home = os.getenv("HOME")
  local config = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
  return config .. "/harper-ls" .. subpath
end

return function()
  local root_dir_fn = fs.find_closest_root({ ".git" })

  local cwd = vim.fn.getcwd()
  local workspace_root = root_dir_fn(cwd)
  local workspace_id
  if workspace_root then
    workspace_id = vim.fn.sha256(workspace_root)
  else
    workspace_id = vim.fn.sha256(cwd)
  end

  return {
    name = "harper",
    filetypes = { "markdown", "gitcommit", "toml", "json", "yaml", "clojure" },

    cmd = mason.command("harper-ls", { "--stdio" }),
    root_dir = root_dir_fn,

    single_file_support = true,

    settings = {
      ["harper-ls"] = {
        userDictPath = db_path("/dictionaries/user.txt"),
        workspaceDictPath = db_path("/dictionaries/workspaces/" .. workspace_id .. ".txt"),
        fileDictPath = db_path("/dictionaries/files/"),
        ignoredLintsPath = db_path("/lints/" .. workspace_id .. "/"),

        dialect = "British",
      },
    },
  }
end
