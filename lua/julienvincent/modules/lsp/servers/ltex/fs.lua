local M = {}

local function ltex_path(type, lang)
  local data_dir = vim.fn.stdpath("data")
  return data_dir .. "/ltex/" .. type .. "/" .. lang .. ".txt"
end

function M.dict_file(lang)
  return ltex_path("dict", lang)
end

function M.disabled_rules_file(lang)
  return ltex_path("disabled-rules", lang)
end

function M.read_file(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return {}
  end

  local lines = {}
  for line in file:lines() do
    table.insert(lines, line)
  end

  file:close()

  return lines
end

local function make_parents(file_path)
  local parent_dir = file_path:match("(.*/)")
  vim.fn.mkdir(parent_dir, "p")
end

function M.write_file(file_path, lines, mode)
  mode = mode or "w"
  make_parents(file_path)

  local file = io.open(file_path, mode)
  if not file then
    vim.notify("Failed to write dict file", vim.log.levels.ERROR)
    return
  end

  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end

  file:close()
end

function M.append_file(file_path, lines)
  M.write_file(file_path, lines, "a")
end

return M
