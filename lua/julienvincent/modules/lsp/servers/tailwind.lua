local mason = require("julienvincent.modules.core.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "tailwind",
  filetypes = {
    "html",
    "markdown",
    "mdx",

    "css",

    "javascriptreact",
    "typescriptreact",
  },

  cmd = mason.command("tailwindcss-language-server", { "--stdio" }),

  root_dir = fs.find_closest_root({
    ".git",
    "package.json",
  }, fs.fallback_fn_cwd),

  single_file_support = true,
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
      },
    },
  },
}
