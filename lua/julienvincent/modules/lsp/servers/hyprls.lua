local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "hyprls",
  filetypes = { "hyprlang" },

  cmd = { "hyprls" },
  root_dir = fs.find_furthest_root({
    "hyperland.conf",
  }, fs.fallback_fn_cwd),

  init_options = {},
}
