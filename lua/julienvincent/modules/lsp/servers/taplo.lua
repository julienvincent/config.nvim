local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "taplo",
  filetypes = {
    "toml",
  },

  cmd = mason.command("taplo", { "lsp", "stdio" }),
  root_dir = fs.find_closest_root({ ".git" }),

  single_file_support = true,
}
