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

local function resolve_server_configs()
  return vim.tbl_map(function(config_factory)
    if type(config_factory) == "function" then
      return config_factory()
    end
    return config_factory
  end, servers)
end

function M.setup()
  local server_configs = resolve_server_configs()

  for _, server_config in ipairs(server_configs) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = server_config.filetypes,
      desc = "Automatically start a language server when entering a buffer",
      callback = function(event)
        vim.schedule(function()
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
        end)
      end,
    })
  end

  local function start()
    local server_names = vim.tbl_map(function(server)
      return server.name
    end, server_configs)

    vim.ui.select(server_names, { prompt = "Select server" }, function(server_name)
      local server_config = vim.tbl_filter(function(server_config)
        return server_config.name == server_name
      end, server_configs)[1]

      if not server_config then
        return
      end

      api.attach_client(vim.api.nvim_get_current_buf(), server_config)
    end)
  end

  local function restart()
    local buf = vim.api.nvim_get_current_buf()
    api.select_client(buf, function(client)
      if not client then
        return
      end
      api.restart_client(buf, client)
    end)
  end

  local function stop()
    local buf = vim.api.nvim_get_current_buf()
    api.select_client(buf, function(client)
      if not client then
        return
      end
      api.stop_client(client.id)
    end)
  end

  require("which-key").add({
    { "<leader>l", group = "lsp" },
  })

  vim.keymap.set("n", "<leader>lR", restart, { desc = "Restart client" })
  vim.keymap.set("n", "<leader>lI", info.show_lsp_info, { desc = "Show LSP info" })

  vim.api.nvim_create_user_command("LspStart", start, { nargs = 0 })
  vim.api.nvim_create_user_command("LspStop", stop, { nargs = 0 })
  vim.api.nvim_create_user_command("LspRestart", restart, { nargs = 0 })
  vim.api.nvim_create_user_command("LspInfo", info.show_lsp_info, { nargs = 0 })
end

return M
