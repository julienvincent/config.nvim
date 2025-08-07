return function()
  local mason = require("julienvincent.modules.core.mason")

  local paths = mason.get_package("pgformatter", "pg_format")
  if not paths then
    return
  end

  return {
    command = paths.bin,
    require_cwd = false,
    args = { "--spaces=2", "--wrap-limit=70", "-" },
    stdin = true,
  }
end
