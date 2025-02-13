local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function is_workspace_root(path)
  local file_path = path .. "/Cargo.toml"
  local content = fs.read_file(file_path)
  if not content then
    return false
  end

  if string.find(content, "%[workspace]") then
    return true
  else
    return false
  end
end

local mason_bin = mason.command("rust-analyzer")

-- This will use the mise install from the system PATH if found. This
-- configuration allows installing mise in a project specific way using mise.
--
-- The env passed here contains the mise-modified PATH.
local function rust_analyzer_system_path(env)
  local result = vim
    .system({ "sh", "-c", "command -v rust-analyzer" }, {
      env = env,
      text = true,
    })
    :wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end

return {
  name = "rust-analyzer",
  filetypes = { "rust" },

  cmd = function(server_config)
    local path = rust_analyzer_system_path(server_config.cmd_env)
    if path then
      return { path }
    end
    return mason_bin()
  end,
  root_dir = fs.find_furthest_root(
    {
      { "Cargo.toml", is_root = is_workspace_root },
    },
    fs.find_closest_root({
      ".git",
    }, fs.fallback_fn_cwd)
  ),

  single_file_support = true,

  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },

  settings = {
    ["rust-analyzer"] = {
      files = {
        excludeDirs = { ".embuild", "target", ".git" },
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}
