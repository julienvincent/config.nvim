local M = {}

local MAX_DEPTH = 20

-- Keeps a 'stack' of previously visited buffers for each window. This is stored as a stack as intermediary
-- buffers are opened all the time during normal development. As they are closed, the are popped off the
-- stack.
--
-- When switching to the previous buffer for a window, we just pop the last buffer off the stack
local PREV_BUFS = {}

local function pop_buf_from_stack(win, buf)
  local bufs = PREV_BUFS[win]

  if bufs and bufs[#bufs] == buf then
    table.remove(bufs, #bufs)
  end

  PREV_BUFS[win] = bufs
end

local function append_buffer_to_stack(win, buf)
  local bufs = PREV_BUFS[win] or {}

  -- Don't append the buffer if it is already on top of the stack
  -- For example this can happen if the buffer is opened more than once and is left multiple times
  if bufs[#bufs] == buf then
    return
  end

  table.insert(bufs, buf)
  if #bufs > MAX_DEPTH then
    table.remove(bufs, 1)
  end

  PREV_BUFS[win] = bufs
end

local function switch_to_prev_buf()
  local win = vim.api.nvim_get_current_win()
  local bufs = PREV_BUFS[win]
  if bufs and #bufs > 0 then
    local prev_buf = bufs[#bufs]
    vim.api.nvim_win_set_buf(win, prev_buf)
  end
end

M.init = function()
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup

  local group = augroup("BufferSwitching", { clear = true })

  vim.keymap.set(
    "n",
    "<C-Tab>",
    switch_to_prev_buf,
    { noremap = true, silent = true, desc = "Switch to previously opened buffer for this window" }
  )

  local function get_window_for_buffer(buf)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == buf then
        return win
      end
    end
    return nil
  end

  autocmd("BufLeave", {
    pattern = "*",
    group = group,
    desc = "Append buffer to window stack when it is left",
    callback = function(event)
      local buf = event.buf
      local win = get_window_for_buffer(buf)

      if not win then
        return
      end

      if not vim.api.nvim_buf_is_loaded(buf) or vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then
        return
      end

      append_buffer_to_stack(win, buf)
    end,
  })

  autocmd("BufEnter", {
    pattern = "*",
    group = group,
    desc = "Pop buffer from window stack when it is entered",
    callback = function(event)
      local buf = event.buf
      local win = get_window_for_buffer(buf)

      if not win then
        return
      end

      if not vim.api.nvim_buf_is_loaded(buf) or vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then
        return
      end

      pop_buf_from_stack(win, buf)
    end,
  })
end

return M
