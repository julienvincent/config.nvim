local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "rust-analyzer",
  filetypes = { "rust", "edn" },

  cmd = mason.command("rust-analyzer"),
  root_dir = fs.find_furthest_root(
    {
      "Cargo.toml",
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
