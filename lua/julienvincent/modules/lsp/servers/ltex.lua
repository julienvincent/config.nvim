local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return function()
  return {
    name = "ltex-ls",
    filetypes = {
      "gitcommit",
      "markdown",
      "html",
      "xhtml",
      "text",
    },

    cmd = mason.command("ltex-ls"),
    root_dir = fs.find_closest_root({ ".git" }, fs.fallback_fn_cwd),

    single_file_support = true,

    settings = {
      ltex = {
        enabled = {
          markdown = true,
          plaintext = true,
        },
        checkFrequency = "save",
        diagnosticSeverity = "warning",
        language = "en-GB",
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en-GB",
        },
      },
    },
  }
end
