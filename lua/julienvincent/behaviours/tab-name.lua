local M = {}

local TAB_NAMES = {}

M.init = function()
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup

  local group = augroup("TabNaming", { clear = true })

  -- Autocommand to store the name of the tab based on the basename of the open directory in NeoTree
  autocmd("BufEnter", {
    pattern = "neo-tree*",
    group = group,
    desc = "Set tab name",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      local tabnr = vim.api.nvim_tabpage_get_number(0)
      local buf = vim.api.nvim_win_get_buf(win)

      local bufname = vim.api.nvim_buf_get_name(buf)
      local basename = vim.fn.fnamemodify(bufname, ":p:h:t")

      TAB_NAMES[tabnr] = basename
    end,
  })
end

M.get_name = function(tabnr)
  return TAB_NAMES[tabnr]
end

return M
