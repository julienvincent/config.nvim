local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "tsserver",
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },

  cmd = mason.command("typescript-language-server", { "--stdio" }),
  root_dir = fs.find_furthest_root({
    "tsconfig.json",
    "package.json",
  }, fs.find_closest_root({ ".git" })),

  single_file_support = true,
  init_options = { hostInfo = "neovim" },
}
