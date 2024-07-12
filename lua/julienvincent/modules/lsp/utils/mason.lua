local M = {}

function M.get_package(pkg, bin)
  local mason_path = require("mason-core.path")
  local registry = require("mason-registry")

  local bin_name = bin or pkg
  local mason_package = registry.get_package(pkg)

  if not mason_package:is_installed() then
    return
  end

  return {
    bin = mason_path.bin_prefix() .. "/" .. bin_name,
    install_dir = mason_package:get_install_path(),
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
