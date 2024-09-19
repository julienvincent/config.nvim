return function ()
  local mason = require("julienvincent.modules.core.mason")

  local paths = mason.get_package("prettierd")
  if not paths then
    return
  end

  return {
    command = paths.bin,
  }
end
