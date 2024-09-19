local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return function()
  return {
    name = "jsonls",
    filetypes = { "json", "jsonc" },

    cmd = mason.command("json-lsp", "vscode-json-language-server", { "--stdio" }),
    root_dir = fs.find_closest_root({ ".git" }),

    single_file_support = true,

    init_options = {
      provideFormatter = true,
    },

    settings = {
      redhat = { telemetry = { enabled = false } },

      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  }
end
