local M = {}

function M.glob_exists_in_dir(dir, globs)
  for _, glob in ipairs(globs) do
    if #vim.fn.glob(vim.api.nvim_call_function("fnamemodify", { dir, ":p" }) .. "/" .. glob) > 0 then
      return true
    end
  end
  return false
end

function M.find_furthest_root(globs)
  local home = vim.fn.expand("~")

  local function traverse(path, root)
    if path == home or path == "/" then
      return root
    end

    local next = vim.fn.fnamemodify(path, ":h")

    if M.glob_exists_in_dir(path, globs) then
      return traverse(next, path)
    end

    return traverse(next, root)
  end

  return function(start_path)
    local result = string.match(start_path, "^%w+://")
    if result then
      return nil
    end

    local furthest_root = traverse(start_path, nil)
    if furthest_root then
      return furthest_root
    end
    return vim.fn.getcwd()
  end
end

return M
