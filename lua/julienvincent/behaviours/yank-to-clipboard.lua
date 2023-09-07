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
      vim.fn.setreg("+", vim.fn.getreg(vim.v.register, 1, 1))
    end,
  })
end

return M
