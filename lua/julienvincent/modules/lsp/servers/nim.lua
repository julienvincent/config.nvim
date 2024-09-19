local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "nimls",
  filetypes = { "nim" },

  cmd = mason.command("nimlangserver"),
  root_dir = fs.find_furthest_root({
    "config.nims",
  }, fs.fallback_fn_cwd),

  single_file_support = true,
  init_options = {},
}
