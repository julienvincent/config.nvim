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

return M
