local fs = require("julienvincent.modules.lsp.utils.fs")

local M = {}

local function hash_filepath(path)
  local escaped_path = vim.fn.shellescape(path)
  local output = vim.fn.system("echo -n " .. escaped_path .. " | sha256sum")
  return vim.fn.trim(output):match("^(%x+)")
end

function M.get_project_config_file(server_name, root_dir)
  if not root_dir then
    return
  end

  local cache_dir = vim.fn.stdpath("data") .. "/lsp/config"
  vim.fn.mkdir(cache_dir, "p")

  local hash = hash_filepath(root_dir)
  return cache_dir .. "/" .. hash .. "." .. server_name .. ".json"
end

function M.load_project_settings(server_name, root_dir)
  local config_file = M.get_project_config_file(server_name, root_dir)
  if not config_file then
    return {}
  end

  local content = fs.read_file(config_file)
  if not content then
    return {}
  end

  return vim.fn.json_decode(content)
end

return M
