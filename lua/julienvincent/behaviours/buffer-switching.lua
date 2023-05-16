local M = {}

-- Initialize an empty table to store previous buffers for each window
local PREV_BUFS = {}

-- Function to switch to the previous buffer
function switch_to_prev_buf()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  -- If there is a previous buffer for the current window, switch to it
  if PREV_BUFS[win] then
    local prev_buf = PREV_BUFS[win]
    vim.api.nvim_win_set_buf(win, prev_buf)
  end

  -- Update the previous buffer for the current window
  PREV_BUFS[win] = buf
end

M.init = function()
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup

  local group = augroup("BufferSwitching", { clear = true })

  -- Bind <C-Tab> to switch to the previous buffer
  vim.keymap.set(
    "n",
    "<C-Tab>",
    switch_to_prev_buf,
    { noremap = true, silent = true, desc = "Switch to previously opened buffer for this window" }
  )

  -- Autocommand to clear previous buffer when a window is closed
  autocmd("WinClosed", {
    pattern = "*",
    group = group,
    desc = "Clear buffers tracked for given window",
    callback = function()
      PREV_BUFS[vim.api.nvim_get_current_win()] = nil
    end,
  })

  -- Autocommand to update previous buffer when a buffer is entered
  autocmd("BufLeave", {
    pattern = "*",
    group = group,
    desc = "Update previous buffer when a buffer is entered",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "" then
        if buf ~= PREV_BUFS[win] then
          PREV_BUFS[win] = buf
        end
      end
    end,
  })
end

return M
