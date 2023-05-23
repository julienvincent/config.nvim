local M = {}

M.map = function(mode, lhs, rhs, desc_or_opts)
  local opts = {}
  if type(desc_or_opts) == "table" then
    opts = desc_or_opts
  else
    opts = { desc = desc_or_opts }
  end
  vim.keymap.set(mode, lhs, rhs, opts)
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
