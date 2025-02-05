local M = {}

local MISE_IS_INSTALLED = nil

local function mise_is_installed()
  if MISE_IS_INSTALLED ~= nil then
    return MISE_IS_INSTALLED
  end

  MISE_IS_INSTALLED = false
  if vim.fn.executable("mise") == 1 then
    MISE_IS_INSTALLED = true
  end

  return MISE_IS_INSTALLED
end

function M.get_mise_env(dir)
  if not mise_is_installed() then
    return {}
  end

  local cmd = { "mise", "env", "--json" }

  local res = vim
    .system(cmd, {
      cwd = dir,
      text = true,
    })
    :wait()

  if res.code ~= 0 then
    return {}
  end

  return vim.fn.json_decode(res.stdout)
end

return M
