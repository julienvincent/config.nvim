local M = {}

function M.is_file_empty(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return true
  end

  local size = file:seek("end")
  file:close()

  return size == 0
end

function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return
  end

  local content = file:read("*all")
  file:close()
  return content
end

function M.glob_exists_in_dir(dir, globs)
  for _, glob in ipairs(globs) do
    local filename = glob
    if type(glob) == "table" then
      filename = glob[1]
    end

    local res = vim.fn.glob(vim.api.nvim_call_function("fnamemodify", { dir, ":p" }) .. "/" .. filename)
    local files = vim.split(res, "\n")

    local non_empty_files = {}
    for i, file in ipairs(files) do
      if not M.is_file_empty(file) then
        non_empty_files[i] = file
      end
    end

    if #non_empty_files > 0 then
      return true, glob
    end
  end

  return false
end

function M.find_furthest_root(globs, fallback_fn)
  local home = vim.fn.expand("~")

  local function traverse(path, root)
    if path == home or path == "/" then
      return root
    end

    local next = vim.fn.fnamemodify(path, ":h")

    local exists, glob = M.glob_exists_in_dir(path, globs)
    if exists then
      if glob and glob.is_root and glob.is_root(path) then
        return path
      end

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

    if fallback_fn and type(fallback_fn) == "function" then
      return fallback_fn(start_path)
    end
  end
end

function M.find_closest_root(globs, fallback_fn)
  local home = vim.fn.expand("~")

  local function traverse(path)
    if path == home or path == "/" then
      return
    end

    if M.glob_exists_in_dir(path, globs) then
      return path
    end

    local next = vim.fn.fnamemodify(path, ":h")
    return traverse(next)
  end

  return function(start_path)
    local result = string.match(start_path, "^%w+://")
    if result then
      return nil
    end

    local furthest_root = traverse(start_path)
    if furthest_root then
      return furthest_root
    end

    if fallback_fn and type(fallback_fn) == "function" then
      return fallback_fn(start_path)
    end
  end
end

function M.fallback_fn_cwd()
  return vim.fn.getcwd()
end

function M.fallback_fn_tmp_dir()
  local tmp_dir = vim.fn.getenv("TMPDIR") .. "nvim-lsp-tmp/"
  vim.fn.mkdir(tmp_dir, "p")
  return tmp_dir
end

function M.find_file_by_glob(dir, glob)
  local files = vim.fn.globpath(dir, glob, 0, 1)
  if #files > 0 then
    return files[1]
  else
    return nil
  end
end

function M.bufname_valid(bufname)
  if
    bufname:match("^/")
    or bufname:match("^[a-zA-Z]:")
    or bufname:match("^zipfile://")
    or bufname:match("^tarfile://")
  then
    return true
  end
  return false
end

return M
