local api = require("julienvincent.modules.lsp.api")

local M = {}

function M.show_lsp_info()
  local NuiLayout = require("nui.layout")
  local NuiPopup = require("nui.popup")
  local NuiLine = require("nui.line")

  local info = NuiPopup({
    border = {
      style = "rounded",
      text = {
        top = " LSP Info ",
        top_align = "left",
      },
    },
    enter = true,
    focusable = true,
  })

  local box = NuiLayout.Box({
    NuiLayout.Box(info, { grow = 1 }),
  }, { dir = "col" })

  local layout = NuiLayout({
    position = "50%",
    relative = "editor",
    size = {
      width = 150,
      height = 30,
    },
  }, box)

  local current_win = vim.api.nvim_get_current_win()
  local current_buffer = vim.api.nvim_get_current_buf()

  layout:mount()

  info:map("n", "q", function()
    vim.api.nvim_set_current_win(current_win)
    layout:unmount()
  end)

  local buf = info.bufnr
  local lines = {}

  local clients = api.get_clients()
  for i, client in ipairs(clients) do
    local header = { { client.name, "Title" } }
    if vim.lsp.buf_is_attached(current_buffer, client.id) then
      table.insert(header, { " :: ", "Comment" })
      table.insert(header, { "[Attached to current buffer]", "InfoFloat" })
    end

    table.insert(lines, header)
    table.insert(lines, { { "id = " }, { client.id .. "", "Number" } })
    table.insert(lines, { { "root_dir = " }, { client.root_dir or "nil", "Green" } })
    table.insert(lines, { { "command = " }, { client.cmd[1], "Green" } })

    if client.single_file_mode then
      table.insert(lines, { { "single_file_mode = " }, { "true", "Boolean" } })
    end

    local buffers = { { "attached_buffers = " } }
    local attached_buffers = api.get_attached_buffers(client.id)
    for i, attached_buf in ipairs(attached_buffers) do
      table.insert(buffers, { "[" })
      table.insert(buffers, { attached_buf .. "", "Number" })
      if i == #attached_buffers then
        table.insert(buffers, { "]" })
      else
        table.insert(buffers, { "], " })
      end
    end

    table.insert(lines, buffers)

    if i ~= #clients then
      table.insert(lines, { { "" } })
    end
  end

  for i, sections in ipairs(lines) do
    local line = NuiLine()
    for _, section in ipairs(sections) do
      line:append(section[1], section[2])
    end
    line:render(buf, -1, i)
  end
end

return M
