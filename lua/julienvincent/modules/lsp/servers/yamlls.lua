local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return function()
  return {
    name = "yamlls",
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },

    cmd = mason.command("yaml-language-server", { "--stdio" }),
    root_dir = fs.find_closest_root({ ".git" }),

    single_file_support = true,

    settings = {
      redhat = { telemetry = { enabled = false } },

      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = require("schemastore").yaml.schemas({
          select = { "GitHub Workflow" },
        }),
      },
    },
  }
end
