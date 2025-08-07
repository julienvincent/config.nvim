local path = require("julienvincent.modules.lsp.utils.path")
local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function is_workspace_root(filepath)
  local file_path = filepath .. "/Cargo.toml"
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

return {
  name = "rust-analyzer",
  filetypes = { "rust" },

  cmd = function(server_config)
    local system_path = path.resolve_executuable("rust-analyzer", {
      env = server_config.cmd_env,
    })
    if system_path then
      return { system_path }
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
        excludeDirs = { ".embuild", "target", ".git", ".jj" },
      },
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        targetDir = true,
      },
    },
  },
}
