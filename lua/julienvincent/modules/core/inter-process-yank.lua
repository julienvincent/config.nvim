local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("InterProcessYank", { clear = true }),
    desc = "Populate registers from yank history",
    callback = function()
      local yank_entry = require("yanky").history.first()

      if yank_entry.regcontents then
        vim.fn.setreg('"', yank_entry.regcontents)
        vim.fn.setreg("0", yank_entry.regcontents)
      end
    end,
  })
end

return M
