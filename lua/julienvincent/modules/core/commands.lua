local M = {}

function M.setup()
  vim.api.nvim_create_user_command("CopyBufPath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg('"', path)
    vim.fn.setreg("+", path)
    vim.notify('cp "' .. path .. '"')
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("CopyCwd", function()
    local cwd = vim.fn.getcwd()
    vim.fn.setreg('"', cwd)
    vim.fn.setreg("+", cwd)
    vim.notify('cp "' .. cwd .. '"')
  end, { nargs = 0 })
end

return M
