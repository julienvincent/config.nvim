local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return function()
  return {
    name = "nil_ls",
    filetypes = { "nix" },

    cmd = mason.command("nil", "nil"),
    root_dir = fs.find_closest_root({ "flake.nix" }),

    single_file_support = true,

    init_options = {
    },

    settings = {
    },
  }
end
