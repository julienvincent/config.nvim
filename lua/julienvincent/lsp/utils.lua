local M = {}

local function is_file_empty(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return true
  end

  local size = file:seek("end")
  file:close()

  return size == 0
end

function M.glob_exists_in_dir(dir, globs)
  for _, glob in ipairs(globs) do
    local res = vim.fn.glob(vim.api.nvim_call_function("fnamemodify", { dir, ":p" }) .. "/" .. glob)
    local files = vim.split(res, "\n")

    local non_empty_files = {}
    for i, file in ipairs(files) do
      if not is_file_empty(file) then
        non_empty_files[i] = file
      end
    end

    if #non_empty_files > 0 then
      return true
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

    if fallback_fn and type(fallback_fn) == "function" then
      return fallback_fn()
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

local function parse_s_tree_output(m2_dir, output)
  local filtered = vim.tbl_filter(function(line)
    return line ~= ""
  end, output)

  local trimmed = vim.tbl_map(function(item)
    local trimmed = string.gsub(item, "^%s*(.-)%s*$", "%1")
    if string.sub(trimmed, 1, 1) == "." then
      return string.sub(trimmed, 3)
    end
    return trimmed
  end, filtered)

  local items_in_use = vim.tbl_filter(function(line)
    return line[1] ~= "X"
  end, trimmed)

  local parsed = vim.tbl_map(function(item)
    local package_and_version = vim.split(item, " ")

    if string.find(package_and_version[2], "/") then
      return nil
    end

    local parts = vim.split(package_and_version[1], "/")
    local group = parts[1]
    local artifact = parts[2]
    local version = package_and_version[2]

    local artifact_path = string.gsub(group, "%.", "/")

    local path_segments = {
      m2_dir,
      "repository",
      artifact_path,
      artifact,
      version,
      artifact .. "-" .. version .. ".jar",
    }
    return table.concat(path_segments, "/")
  end, items_in_use)

  return vim.tbl_filter(function(lib)
    return lib
  end, parsed)
end

function M.find_third_party_libs(m2_dir, project_root, callback)
  if vim.fn.executable("clojure") ~= 1 then
    return callback({})
  end

  local file_exists = vim.loop.fs_stat(project_root .. "/deps.edn")
  if not file_exists then
    return callback({})
  end

  return vim.fn.jobstart({ "clojure", "-Stree" }, {
    on_stdout = function(_, data)
      local libs = parse_s_tree_output(m2_dir, data)
      callback(libs)
    end,
    on_stderr = function(_, data)
      if data[1] ~= "" then
        print("Failed to call clojure -Stree", vim.inspect(data))
        callback({})
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    cwd = project_root,
  })
end

return M
