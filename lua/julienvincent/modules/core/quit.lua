local M = {}

local function buf_is_modified(buf)
  local writable = vim.api.nvim_get_option_value("modifiable", { buf = buf })
  local modified = vim.api.nvim_get_option_value("modified", { buf = buf })

  return writable and modified
end

local function find_unsaved_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local result = {}
  for _, buf in ipairs(buffers) do
    if buf_is_modified(buf) then
      table.insert(result, buf)
    end
  end
  return result
end

local function handle_each_unsaved_buffer(buffers, cb, i)
  i = i or 1
  local buf = buffers[i]
  if not buf then
    return cb()
  end

  vim.api.nvim_set_current_buf(buf)
  local bufname = vim.api.nvim_buf_get_name(buf)

  vim.ui.select({ "Delete", "Cancel" }, {
    prompt = "Unsaved buffer " .. (bufname or "[No Name]") .. ". What do you want to do?",
  }, function(result)
    if not result then
      return
    end

    if result == "Cancel" then
      return
    end

    if result == "Delete" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end

    handle_each_unsaved_buffer(buffers, cb, i + 1)
  end)
end

M.setup = function()
  local saving = require("julienvincent.modules.core.auto-save")

  vim.keymap.set("n", "<leader>qq", function()
    saving.write_all_buffers()

    local unsaved = find_unsaved_buffers()
    handle_each_unsaved_buffer(unsaved, function()
      vim.api.nvim_command("qa")
    end)
  end, { desc = "Save and quit" })
end

return M
