local capabilities = require("julienvincent.modules.lsp.capabilities")
local settings = require("julienvincent.modules.lsp.settings")
local keymaps = require("julienvincent.modules.lsp.keymaps")
local fs = require("julienvincent.modules.lsp.utils.fs")
local mise = require("julienvincent.modules.core.mise")

local CLIENTS = {}
local M = {}

function M.get_clients()
  return CLIENTS
end

local function create_client(buf, server_config)
  local config = vim.tbl_deep_extend("force", server_config, {
    name = server_config.name,
    capabilities = capabilities.make_client_capabilities(),
    cmd_cwd = server_config.root_dir,
    cmd_env = mise.get_mise_env(server_config.root_dir),

    on_error = function()
      vim.notify("LSP failed to start", vim.log.levels.ERROR)
    end,

    on_attach = function(_, bufnr)
      vim.bo[bufnr].formatexpr = nil
      vim.bo[bufnr].omnifunc = nil

      keymaps.setup_on_attach_keybinds(bufnr)
    end,

    handlers = {
      ["window/showMessage"] = function(_, result, _)
        local type = 5 - result.type
        vim.notify(result.message, type)
      end,
    },
  })

  local project_settings = settings.load_project_settings(server_config.name, server_config.root_dir)
  config.settings = vim.tbl_deep_extend("force", config.settings or {}, project_settings)

  local opts = {
    bufnr = buf,
    reuse_client = function()
      return false
    end,
  }

  if server_config.start then
    return server_config.start(config, opts)
  end

  return vim.lsp.start(config, opts)
end

local function remove_client(client_id)
  for i, client in ipairs(CLIENTS) do
    if client.id == client_id then
      table.remove(CLIENTS, i)
    end
  end
end

function M.attach_client(buf, server_config)
  local buf_path = vim.api.nvim_buf_get_name(buf)

  local root_dir = nil
  if server_config.root_dir then
    if #buf_path > 0 and fs.bufname_valid(buf_path) then
      root_dir = server_config.root_dir(buf_path)
    end
  end

  local cmd = server_config.cmd
  if type(cmd) == "function" then
    cmd = cmd()
  end

  if not cmd then
    vim.notify_once(
      "LSP Client " .. server_config.name .. " failed to resolve to a valid executable",
      vim.log.levels.WARN
    )
    return
  end

  if not root_dir and not server_config.single_file_support then
    return
  end

  local active_client
  for _, client in ipairs(CLIENTS) do
    if client.root_dir == root_dir and client.name == server_config.name then
      active_client = vim.lsp.get_client_by_id(client.id)
      break
    end
  end

  if active_client then
    if vim.lsp.buf_is_attached(buf, active_client.id) then
      return
    end

    vim.lsp.buf_attach_client(buf, active_client.id)
    return
  end

  local config = vim.deepcopy(server_config)

  config.cmd = cmd
  config.root_dir = root_dir
  config.on_exit = function(_, _, client_id)
    remove_client(client_id)
  end

  local client_id = create_client(buf, config)

  if not client_id then
    vim.notify("Failed to start client " .. server_config.name, vim.log.levels.ERROR)
    return
  end

  table.insert(CLIENTS, {
    id = client_id,
    name = server_config.name,

    single_file_mode = not root_dir,
    root_dir = root_dir,
    cmd = cmd,

    config = server_config,
  })
end

function M.stop_client(client_id)
  vim.lsp.stop_client(client_id)
  remove_client(client_id)
end

function M.restart_client(buf, client)
  M.stop_client(client.id)
  M.attach_client(buf, client.config)
end

function M.get_attached_buffers(client_id)
  local result = {}
  local attached_buffers = vim.lsp.get_client_by_id(client_id).attached_buffers
  for attached_buf, _ in pairs(attached_buffers) do
    table.insert(result, attached_buf)
  end
  return result
end

function M.select_client(buf, cb)
  local clients = {}
  for _, client in ipairs(CLIENTS) do
    for _, client_buf in pairs(M.get_attached_buffers(client.id)) do
      if client_buf == buf then
        table.insert(clients, client)
      end
    end
  end

  if #clients == 1 then
    return cb(clients[1])
  end

  local function as_name(client)
    return "[" .. client.id .. "] " .. client.name
  end

  local names = vim.tbl_map(as_name, clients)

  vim.ui.select(names, { prompt = "Select client" }, function(selection)
    local client = vim.tbl_filter(function(client)
      return as_name(client) == selection
    end, clients)[1]
    cb(client)
  end)
end

return M
