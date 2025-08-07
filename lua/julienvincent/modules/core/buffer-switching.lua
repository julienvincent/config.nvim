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

local function remove_buffer_from_stack(win, buf)
  local bufs = PREV_BUFS[win] or {}
  remove_element_from_table(bufs, buf)
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
      table.insert(results, { filename = filename, buf = buf })
    end
  end

  return results
end

M.switch_to_prev_buf = function()
  local win = vim.api.nvim_get_current_win()
  local bufs = PREV_BUFS[win]
  if bufs and #bufs > 0 then
    local prev_buf = bufs[#bufs]
    vim.api.nvim_win_set_buf(win, prev_buf)
  end
end

local function create_items(win)
  local files = get_files_for_picker(win)
  local items = {}
  for idx, file in ipairs(files) do
    table.insert(items, {
      idx = idx,
      text = file.filename,
      file = file.filename,
      bufnr = file.buf,
    })
  end
  return items
end

function M.pick_buffer()
  local format = require("snacks.picker.format")

  local win = vim.api.nvim_get_current_win()

  require("snacks.picker").pick({
    items = create_items(win),
    format = format.filename,
    title = "",
    prompt = "Quick Switch❯ ",
    show_empty = true,
    layout = {
      hidden = { "preview" },
      layout = {
        height = 0.30,
        width = 0.3,
        min_width = 30,
        row = 0.2,
      },
    },
    win = {
      input = {
        keys = {
          ["<Esc>"] = { "close", mode = { "n", "i" } },

          ["<Tab>"] = { "list_down", mode = { "i", "n" } },
          ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },

          ["<C-x>"] = {
            "delete",
            mode = { "i", "n" },
          },

          ["<C-n>"] = {
            "select_and_next",
            mode = { "i", "n" },
          },
        },
      },
    },

    actions = {
      delete = function(picker, item)
        if not item then
          return
        end
        remove_buffer_from_stack(win, item.bufnr)
        vim.api.nvim_buf_delete(item.bufnr, { force = true })
        local items = create_items(win)
        picker.finder.items = items
        picker.list.items = items
        picker.list:update({ force = true })
      end,
      confirm = function(picker, item)
        picker:close()
        if not item then
          return
        end
        vim.schedule(function()
          vim.api.nvim_set_current_buf(item.bufnr)
        end)
      end,
    },
  })
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
      local is_named = vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= ""

      if not is_valid or not is_loaded or is_named then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(buf)
      local stat = vim.loop.fs_stat(bufname)
      local special_file = string.match(bufname, "^[%a][%w+.-]*://") ~= nil

      if (not stat or stat.type == "directory") and not special_file then
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
