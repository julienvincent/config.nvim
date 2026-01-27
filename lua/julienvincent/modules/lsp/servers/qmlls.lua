local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "qmlls",
  filetypes = { "qml", "qmljs" },

  cmd = { "qmlls" },
  root_dir = fs.find_furthest_root({
    ".qmlls.ini",
  }, fs.fallback_fn_cwd),
}
