local M = {}

-- This will use the mise install from the system PATH if found. This
-- configuration allows installing mise in a project specific way using mise.
--
-- The env passed here contains the mise-modified PATH.
function M.resolve_executuable(executable, opts)
  opts = vim.tbl_deep_extend("force", opts or {}, {
    text = true,
  })
  local result = vim.system({ "sh", "-c", "command -v " .. executable }, opts):wait()
  if result.code == 0 then
    return vim.trim(result.stdout)
  end
end

function M.command(opts)
  local mason = require("julienvincent.modules.core.mason")
  local mason_resolver
  if opts.mason_package then
    mason_resolver = mason.command(opts.mason_package, opts.bin, opts.args)
  end

  return function(server_config)
    local system_path = M.resolve_executuable(opts.bin, {
      env = server_config.cmd_env,
    })
    if system_path then
      local cmd = { system_path }
      for _, arg in ipairs(opts.args or {}) do
        table.insert(cmd, arg)
      end
      return cmd
    end

    if mason_resolver then
      return mason_resolver()
    end
  end
end

return M
