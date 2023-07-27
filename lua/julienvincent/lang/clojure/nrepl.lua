local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local config = require("telescope.config")

local M = {}

function M.get_repl_status(not_connected_msg)
  if vim.bo.filetype ~= "clojure" then
    return not_connected_msg
  end

  local ok, nrepl_state = pcall(require, "conjure.client.clojure.nrepl.state")
  if not ok then
    return not_connected_msg
  end

  local conn = nrepl_state.get("conn")
  if not conn then
    return not_connected_msg
  end

  local host = conn.host
  local port = conn.port
  local port_file_path = conn.port_file_path

  if port then
    if port_file_path then
      local dir = string.match(port_file_path, "^.*/(.+)$")
      host = dir or "local"
    end

    return " " .. host .. ":" .. port
  end
end

local function connect_to_nrepl_server(connection_details)
  local nrepl_server = require("conjure.client.clojure.nrepl.server")
  nrepl_server.connect({
    host = connection_details.host or "localhost",
    port = connection_details.port,
    port_file_path = connection_details.dir,
    cb = function()
      print("Connected to nrepl server at localhost:" .. connection_details.port)
    end,
  })
end

local function read_nrepl_ports(dirs)
  local results = {}
  for _, dir in ipairs(dirs) do
    local file_path = dir .. "/.nrepl-port"
    local file = io.open(file_path, "r")
    if file then
      local port = file:read("*all")
      file:close()
      if port ~= "" then
        table.insert(results, { dir = dir, port = port })
      end
    end
  end
  return results
end

local function find_nrepl_processes()
  local cmd = [[
    ps aux | \
    grep java | \
    grep nrepl | \
    awk '{print $2}' | \
    xargs -I % sh -c 'lsof -p % | grep cwd | awk "{print \$9}"'
  ]]

  local res = vim.fn.system(cmd)
  local directories = vim.split(res, "\n")
  return read_nrepl_ports(directories)
end

function M.find_repls()
  local opts = themes.get_dropdown({})

  pickers
    .new(opts, {
      prompt_title = "Find Repls",

      sorter = config.values.generic_sorter(opts),
      finder = finders.new_table({
        results = find_nrepl_processes(),
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.dir .. " :: " .. entry.port,
            ordinal = entry.dir,
          }
        end,
      }),

      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          connect_to_nrepl_server(selection.value)
        end)
        return true
      end,
    })
    :find()
end

function M.direct_connect()
  vim.ui.input({
    prompt = "Enter connection details",
    default = "localhost:",
    kind = "center",
  }, function(value)
    if not value then
      return
    end

    local host, port = string.match(value, "([^:]+):(.*)")
    if host == "" or port == "" or not host or not port then
      print("Invalid input")
      return
    end

    connect_to_nrepl_server({
      host = host,
      port = port,
    })
  end)
end

return M
