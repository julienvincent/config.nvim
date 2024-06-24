-- This is an alternative implementation to `telescope.builtin.oldfiles` which renders files a bit better

local M = {}

local MAX_DEPTH = 20

-- Keeps a 'stack' of previously visited buffers for each window. This is stored as a stack as intermediary
-- buffers are opened all the time during normal development. As they are closed, the are popped off the
-- stack.
--
-- When switching to the previous buffer for a window, we just pop the last buffer off the stack
local PREV_BUFS = {}

local function get_window_for_buffer(buf)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      return win
    end
  end
  return nil
end

local function remove_element_from_table(tbl, element)
  for i = #tbl, 1, -1 do
    if tbl[i] == element then
      table.remove(tbl, i)
    end
  end
end

local function append_buffer_to_stack(win, buf)
  local bufs = PREV_BUFS[win] or {}

  remove_element_from_table(bufs, buf)
  table.insert(bufs, buf)

  if #bufs > MAX_DEPTH then
    table.remove(bufs, 1)
  end

  PREV_BUFS[win] = bufs
end

local function get_files_for_picker(win)
  local bufs = PREV_BUFS[win] or {}

  local results = {}
  for i = #bufs - 1, 1, -1 do
    local buf = bufs[i]
    local is_valid = vim.api.nvim_buf_is_valid(buf)
    if is_valid then
      local filename = vim.api.nvim_buf_get_name(buf)
      table.insert(results, filename)
    end
  end

  return results
end

local function included_in_table(tbl, element)
  for _, item in ipairs(tbl) do
    if item == element then
      return true
    end
  end
  return false
end

local function remove_files_from_stack(win, files)
  local results = {}

  for _, buf in ipairs(PREV_BUFS[win]) do
    local is_valid = vim.api.nvim_buf_is_valid(buf)
    if is_valid then
      local filename = vim.api.nvim_buf_get_name(buf)
      if not included_in_table(files, filename) then
        table.insert(results, buf)
      end
    end
  end

  PREV_BUFS[win] = results
end

M.switch_to_prev_buf = function()
  local win = vim.api.nvim_get_current_win()
  local bufs = PREV_BUFS[win]
  if bufs and #bufs > 0 then
    local prev_buf = bufs[#bufs]
    vim.api.nvim_win_set_buf(win, prev_buf)
  end
end

function M.pick_buffer()
  local fzf = require("fzf-lua")

  local win = vim.api.nvim_get_current_win()

  local opts = {
    prompt = "Quick Switch❯ ",
    previewer = "builtin",
    winopts = {
      height = 0.60,
      width = 0.40,
      row = 0.1,
    },
    fzf_opts = {
      ["--layout"] = "reverse",
    },
    keymap = {
      fzf = {
        ["tab"] = "down",
        ["shift-tab"] = "up",
      },
    },
    actions = {
      ["default"] = fzf.actions.file_edit,

      ["ctrl-d"] = {
        function(selected)
          local paths = {}
          for _, path in ipairs(selected) do
            local new_path = string.sub(path, 7)
            table.insert(paths, vim.loop.cwd() .. "/" .. new_path)
          end
          remove_files_from_stack(win, paths)
        end,
        fzf.actions.resume,
      },
    },
  }

  local function builder(cb)
    local files = get_files_for_picker(win)
    for _, file in ipairs(files) do
      cb(fzf.make_entry.file(string.gsub(file, vim.loop.cwd() .. "/", ""), {
        file_icons = true,
        color_icons = true,
      }))
    end
    cb()
  end

  fzf.fzf_exec(builder, opts)
end

M.setup = function()
  local group = vim.api.nvim_create_augroup("BufferSwitching", { clear = true })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = group,
    desc = "Pop buffer from window stack when it is entered",
    callback = function(event)
      local buf = event.buf
      local win = get_window_for_buffer(buf)

      if not win then
        return
      end

      local is_valid = vim.api.nvim_buf_is_valid(buf)
      local is_loaded = vim.api.nvim_buf_is_loaded(buf)
      local is_named = vim.api.nvim_buf_get_option(buf, "buftype") ~= ""

      if not is_valid or not is_loaded or is_named then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(buf)
      local stat = vim.loop.fs_stat(bufname)

      if not stat or stat.type == "directory" then
        return
      end

      append_buffer_to_stack(win, buf)
    end,
  })

  vim.keymap.set("n", "<Tab>", M.pick_buffer, {
    noremap = true,
    silent = true,
    desc = "Buffer quick-switch",
  })

  vim.keymap.set("n", "<C-Tab>", "<C-^>", {
    noremap = true,
    silent = true,
    desc = "Toggle previous buffer",
  })
end

return M
