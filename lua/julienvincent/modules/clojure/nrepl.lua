local bindings = require("julienvincent.modules.clojure.nrepl.bindings")
local nrepl = require("julienvincent.modules.clojure.nrepl.api")
local saving = require("julienvincent.modules.core.auto-save")

local function reload_namespaces()
  saving.write_all_buffers()
  nrepl.eval("jv.repl", "(reload-namespaces)")
end

local function reset()
  bindings.run_binding(":restart!", function()
    reload_namespaces()
  end)
end

local function stop()
  bindings.run_binding(":stop!")
end

local function sync_deps()
  nrepl.eval("jv.repl", "(sync-deps)")
end

local M = {}

function M.setup()
  local wk = require("which-key")

  wk.add({
    { "<leader>c", group = "Repl" },
    { "<localleader>l", group = "Conjure Log" },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "clojure",
    callback = function(event)
      vim.api.nvim_set_option_value("textwidth", 80, {
        buf = event.buf,
      })

      wk.add({
        { "<localleader>e", group = "Eval", buffer = event.buf },
        { "<localleader>n", group = "Clojure Namespace", buffer = event.buf },
      })

      vim.keymap.set("n", "<leader>cf", nrepl.find_repls, {
        desc = "Find and connect to running repls",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>cp", nrepl.direct_connect, {
        desc = "Connect via port",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>§", reset, {
        desc = "Eval 'jv.repl/reset",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>`", reset, {
        desc = "Eval 'jv.repl/reset",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>!", stop, {
        desc = "Eval 'jv.repl/stop",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<localleader>nr", reload_namespaces, {
        desc = "Eval 'jv.repl/reload-namespaces",
        buffer = event.buf,
      })

      vim.api.nvim_create_user_command("Repl", function(opts)
        local params = vim.split(opts.args, " ")
        local command = params[1]

        if command == "sync-deps" then
          sync_deps()
          vim.notify("Deps synced")
          return
        end

        vim.notify("Unknown command " .. command, vim.log.levels.ERROR)
      end, {
        nargs = "+",
        complete = function(arg, _, _)
          local completions = { "sync-deps" }
          return vim.tbl_filter(function(item)
            return item:match("^" .. arg)
          end, completions)
        end,
        desc = "Execute Clojure commands",
      })
    end,
  })
end

return M
