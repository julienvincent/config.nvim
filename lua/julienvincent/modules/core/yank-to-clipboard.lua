local M = {}

local ignore_registers = { "_", "+" }

M.setup = function()
  vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("ClipboardYank", { clear = true }),
    desc = "Yank to clipboard",
    callback = function()
      if vim.tbl_contains(ignore_registers, vim.v.register) then
        return
      end
      if vim.v.operator ~= "y" then
        return
      end

      local value = vim.fn.getreg(vim.v.register, 1)
      local type = vim.fn.getregtype(vim.v.register)
      vim.fn.setreg("+", value, type)
      vim.fn.setreg("p", value, type)
    end,
  })
end

return M
