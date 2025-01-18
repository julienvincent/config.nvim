local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

local function is_workspace_root(path)
  local file_path = path .. "/Cargo.toml"
  local file = io.open(file_path, "r")
  if not file then
    return false
  end

  local content = file:read("*all")
  file:close()

  if string.find(content, "%[workspace]") then
    return true
  else
    return false
  end
end

return {
  name = "rust-analyzer",
  filetypes = { "rust", "edn" },

  cmd = mason.command("rust-analyzer"),
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
    },
  },
}
