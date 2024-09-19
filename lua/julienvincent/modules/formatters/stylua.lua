return function()
  local mason = require("julienvincent.modules.core.mason")

  local paths = mason.get_package("stylua")
  if not paths then
    return
  end

  return {
    command = paths.bin,
    args = {
      "--search-parent-directories",
      "--stdin-filepath",
      "$FILENAME",
      "-",
      "--indent-type",
      "Spaces",
      "--indent-width",
      "2",
    },
  }
end
