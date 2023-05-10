local M = {}

M.map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

M.lsp_map = function(lhs, rhs, bufnr, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

M.autocmd = function(group, triggers, fn)
  local group_id = vim.api.nvim_create_augroup(group)
  vim.api.nvim_create_autocmd(triggers, {
    group = group_id,
    callback = fn,
  })
end

return M
