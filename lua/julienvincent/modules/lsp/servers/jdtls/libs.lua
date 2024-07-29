local fs = require("julienvincent.modules.lsp.utils.fs")

local M = {}

local function parse_classpath(raw_paths)
  local paths = vim.split(raw_paths, ":")

  local jar_paths = vim.tbl_filter(function(line)
    if not line or line == "" then
      return false
    end
    if not string.find(line, ".jar") then
      return false
    end
    return true
  end, paths)

  return jar_paths
end

function M.find_third_party_libs(project_root)
  if vim.fn.executable("kmono") ~= 1 then
    return {}
  end

  local deps_file = project_root .. "/deps.edn"
  local file_exists = vim.loop.fs_stat(deps_file)
  if not file_exists or fs.is_file_empty(deps_file) then
    return {}
  end

  local libs = {}
  local job_id = vim.fn.jobstart({ "kmono", "cp" }, {
    on_stdout = function(_, data)
      libs = parse_classpath(data[1])
    end,
    -- on_stderr = function(_, data)
    --   if data[1] ~= "" then
    --     print("Failed to call clojure -Spath", vim.inspect(data))
    --     callback({})
    --   end
    -- end,
    stdout_buffered = true,
    stderr_buffered = true,
    cwd = project_root,
  })

  vim.fn.jobwait({ job_id })
  return libs
end

return M
