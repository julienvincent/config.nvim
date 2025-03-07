local settings = require("julienvincent.modules.lsp.settings")
local api = require("julienvincent.modules.lsp.api")

local M = {}

function M.open_server_config()
  local buf = vim.api.nvim_get_current_buf()
  api.select_client(buf, function(client)
    if not client then
      return
    end
    local config_file = settings.get_project_config_file(client.name, client.root_dir)
    if not config_file then
      return
    end

    vim.cmd("vnew " .. config_file)

    local settings_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("LspSettings", { clear = true }),
      buffer = settings_buf,
      callback = function()
        local project_settings = settings.load_project_settings(client.name, client.root_dir)
        local new_settings = vim.tbl_deep_extend("force", client.config.settings or {}, project_settings)

        local lsp_client = vim.lsp.get_client_by_id(client.id)
        if not lsp_client then
          return
        end

        lsp_client:notify("workspace/didChangeConfiguration", {
          settings = new_settings,
        })
      end,
    })

    vim.keymap.set("n", "q", function()
      vim.cmd("w")
      vim.cmd("close")
    end, {
      buffer = settings_buf,
    })
  end)
end

return M
