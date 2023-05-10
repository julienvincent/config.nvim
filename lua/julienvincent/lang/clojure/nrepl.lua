local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local M = {}

function M.get_repl_status(not_connected_msg)
  if vim.bo.filetype == "clojure" then
    local ok, nrepl_state = pcall(require, "conjure.client.clojure.nrepl.state")
    if ok then
      local conn = nrepl_state.get("conn")
      if conn then
        local host = conn.host
        local port = conn.port
        local port_file_path = conn.port_file_path
        if port then
          if port_file_path then
            if port_file_path == ".nrepl-port" or port_file_path == "nrepl.port" then
              port_file_path = vim.fn.getcwd() .. "/" .. port_file_path
            end
            local app, _ = string.match(port_file_path, "^.+/(.+)/(.+)$")
            return " " .. (app or "local") .. ":" .. port
          end
          return host .. ":" .. port
        end
      end
    end
  end
  return not_connected_msg
end

local function run_selection(prompt_bufnr)
  actions.select_default:replace(function()
    local nrepl_server = require("conjure.client.clojure.nrepl.server")
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    local port = io.lines(selection.path)()
    nrepl_server.connect({
      host = "localhost",
      port = port,
      port_file_path = selection.path,
      cb = function()
        print("Connected.")
      end,
    })
  end)
  return true
end

local find_opts = require("telescope.themes").get_dropdown({
  borderchars = {
    { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
    results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
    preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  },
  width = 0.8,
  previewer = false,
  prompt_title = "REPLs",
  cwd = "~/code",
  find_command = {
    "rg",
    "--files",
    "--with-filename",
    "--hidden",
    "-g",
    "!.joyride",
    "-g",
    ".nrepl-port",
    "-g",
    "nrepl.port",
  },
  attach_mappings = run_selection,
})

function M.find_repls()
  require("telescope.builtin").find_files(find_opts)
end

STATES = { "default" }

function M.create_new_repl_session(name)
  vim.api.nvim_command("ConjureClientState " .. name)
  STATES[#STATES + 1] = name
end

function M.switch_active_repl()
  pickers
    .new({}, {
      prompt_title = "Active Repl Connections",
      finder = finders.new_table({
        results = STATES,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.api.nvim_command("ConjureClientState " .. selection[1])
        end)

        return true
      end,
    })
    :find()
end

return M
