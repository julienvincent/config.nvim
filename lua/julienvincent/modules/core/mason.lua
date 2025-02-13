local M = {}

function M.get_package(pkg, bin)
  local registry = require("mason-registry")
  if not registry.is_installed(pkg) then
    return
  end

  local bin_name = bin or pkg

  return {
    bin = vim.fn.expand("$MASON/bin/" .. bin_name),
    share_dir = vim.fn.expand("$MASON/share/" .. pkg),
  }
end

function M.command(pkg, bin, args)
  if type(bin) == "table" then
    args = bin
    bin = nil
  end

  return function()
    local paths = M.get_package(pkg, bin)
    if not paths then
      return
    end
    local cmd = { paths.bin }
    for _, arg in ipairs(args or {}) do
      table.insert(cmd, arg)
    end
    return cmd
  end
end

return M
