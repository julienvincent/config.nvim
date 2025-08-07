local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "css",
  filetypes = {
    "css",
  },

  cmd = mason.command("css-lsp", "vscode-css-language-server", { "--stdio" }),

  root_dir = fs.find_closest_root({
    ".git",
    "package.json",
  }, fs.fallback_fn_cwd),

  init_options = { provideFormatter = true },

  single_file_support = true,
  settings = {
    css = { validate = true },
  },
}
