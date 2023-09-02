local map = require("julienvincent.helpers.keys").map

local function undo_with_stable_cursor()
  local cursor_pos = vim.fn.getcurpos()
  vim.cmd("undo")
  vim.fn.setpos(".", cursor_pos)
end

local M = {}

M.setup = function()
  map("n", "u", undo_with_stable_cursor, {
    desc = "Undo",
    noremap = true,
    silent = true,
  })
end

return M
