local M = {}

local function set_title()
  vim.opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

M.setup = function()
  vim.opt.title = true

  set_title()

  vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = set_title,
  })
end

return M
