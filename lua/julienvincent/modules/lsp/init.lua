local servers = require("julienvincent.modules.lsp.servers")
local info = require("julienvincent.modules.lsp.ui.info")
local fs = require("julienvincent.modules.lsp.utils.fs")
local api = require("julienvincent.modules.lsp.api")

local M = {}

local function resolve_server_configs()
  return vim.tbl_map(function(config_factory)
    if type(config_factory) == "function" then
      return config_factory()
    end
    return config_factory
  end, servers)
end

local function buf_is_valid(buf, server_config)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
  local bufname = vim.api.nvim_buf_get_name(buf)

  if buftype == "nofile" then
    return
  end

  if #bufname == 0 and not server_config.single_file_support then
    return
  end

  if #bufname ~= 0 and not fs.bufname_valid(bufname) then
    return
  end

  return true
end

function M.setup()
  local server_configs = resolve_server_configs()

  for _, server_config in ipairs(server_configs) do
    local buf_is_valid_fn = buf_is_valid
    if server_config.buf_is_valid then
      buf_is_valid_fn = server_config.buf_is_valid
    end

    vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
      desc = "Automatically start a language server when entering a buffer",
      callback = function(event)
        local buf = event.buf

        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
        local matches = vim.tbl_filter(function(ft)
          return filetype == ft
        end, server_config.filetypes)
        if #matches == 0 then
          return
        end

        vim.schedule(function()
          if not buf_is_valid_fn(buf, server_config) then
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

  local function stop(params)
    local args = params.fargs
    if args[1] == "all" then
      for _, client in ipairs(api.get_clients()) do
        api.stop_client(client.id)
      end
      return
    end

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
  vim.api.nvim_create_user_command("LspStop", stop, { nargs = "*" })
  vim.api.nvim_create_user_command("LspRestart", restart, { nargs = 0 })
  vim.api.nvim_create_user_command("LspInfo", info.show_lsp_info, { nargs = 0 })
end

return M
