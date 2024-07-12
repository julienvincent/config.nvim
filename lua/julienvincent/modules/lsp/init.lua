local servers = require("julienvincent.modules.lsp.servers")
local info = require("julienvincent.modules.lsp.ui.info")
local api = require("julienvincent.modules.lsp.api")

local M = {}

local function bufname_valid(bufname)
  if
    bufname:match("^/")
    or bufname:match("^[a-zA-Z]:")
    or bufname:match("^zipfile://")
    or bufname:match("^tarfile:")
  then
    return true
  end
  return false
end

function M.setup()
  for _, config_factory in ipairs(servers) do
    local server_config = config_factory
    if type(server_config) == "function" then
      server_config = server_config()
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = server_config.filetypes,
      desc = "Automatically start a language server when entering a buffer",
      callback = function(event)
        local buf = event.buf

        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        local bufname = vim.api.nvim_buf_get_name(buf)

        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        if buftype == "nofile" then
          return
        end

        if #bufname == 0 and not server_config.single_file_support then
          return
        end

        if #bufname ~= 0 and not bufname_valid(bufname) then
          return
        end

        api.attach_client(buf, server_config)
      end,
    })
  end

  require("which-key").add({
    { "<leader>l", group = "lsp" },
  })

  vim.keymap.set("n", "<leader>lR", function()
    local buf = vim.api.nvim_get_current_buf()
    api.select_client(buf, function(client)
      if not client then
        return
      end
      api.restart_client(buf, client)
    end)
  end, { desc = "Restart client" })

  vim.keymap.set("n", "<leader>lS", function()
    local buf = vim.api.nvim_get_current_buf()
    api.select_client(buf, function(client)
      if not client then
        return
      end
      api.stop_client(client.id)
    end)
  end, { desc = "Stop client" })

  vim.keymap.set("n", "<leader>lI", function()
    info.show_lsp_info()
  end, { desc = "Show LSP info" })
end

return M
