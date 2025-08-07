local path = require("julienvincent.modules.lsp.utils.path")
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

return {
  name = "rust-analyzer",
  filetypes = { "rust" },

  cmd = path.command({
    bin = "rust-analyzer",
    mason_package = "rust-analyzer",
  }),
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
