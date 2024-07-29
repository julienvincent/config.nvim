local M = {}

function M.buf_is_visible(buf)
  local tabpage = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(tabpage)

  for _, win in ipairs(windows) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return true
    end
  end

  return false
end

function M.buf_is_writable(buf)
  local bufname = vim.api.nvim_buf_get_name(buf)

  local buftype = vim.api.nvim_get_option_value("buftype", {
    buf = buf,
  })

  local writable = #bufname > 0
    and vim.api.nvim_get_option_value("modifiable", { buf = buf })
    and vim.fn.filereadable(bufname) == 1
    and vim.fn.filewritable(bufname) == 1
    and buftype ~= "nofile"
    and buftype ~= "nowrite"

  return vim.api.nvim_get_option_value("modified", { buf = buf }) and writable
end

function M.get_hidden_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local hidden_buffers = {}

  for _, buf in ipairs(buffers) do
    local is_loaded = vim.api.nvim_buf_is_loaded(buf)
    local is_visible = M.buf_is_visible(buf)
    if is_loaded and not is_visible then
      table.insert(hidden_buffers, buf)
    end
  end

  return hidden_buffers
end

function M.write_buffer(buf)
  if M.buf_is_writable(buf) then
    vim.api.nvim_buf_call(buf, function()
      vim.api.nvim_command("write")
    end)
  end
end

function M.write_all_hidden_buffers()
  local hidden_buffers = M.get_hidden_buffers()
  for _, buf in ipairs(hidden_buffers) do
    M.write_buffer(buf)
  end
end

function M.write_all_buffers()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    M.write_buffer(buf)
  end
end

function M.setup()
  local autocmd = vim.api.nvim_create_autocmd
  local group = vim.api.nvim_create_augroup("AutoSaving", { clear = true })

  autocmd({ "BufLeave", "BufEnter", "TabLeave" }, {
    desc = "Save buffers when they are no longer visible",
    pattern = "*",
    group = group,
    callback = M.write_all_hidden_buffers,
  })

  autocmd("FocusLost", {
    desc = "Save all buffers when focus is lost",
    pattern = "*",
    group = group,
    callback = M.write_all_buffers,
  })

  vim.keymap.set("n", "<localleader>s", "<Cmd>w<Cr>", { desc = "Save buffer" })
  vim.keymap.set("n", "<localleader>S", M.write_all_buffers, { desc = "Save all buffers" })
end

return M
