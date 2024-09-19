local nrepl = require("julienvincent.modules.clojure.nrepl.api")
local saving = require("julienvincent.modules.core.auto-save")

local function reload_namespaces()
  saving.write_all_buffers()
  nrepl.eval("user", "(reload-namespaces)")
end

local function reset()
  reload_namespaces()
  nrepl.eval("user", "(do (restart-system) nil)")
end

local function stop()
  nrepl.eval("user", "(do (stop-system) nil)")
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
        desc = "Eval 'user/reset",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>`", reset, {
        desc = "Eval 'user/reset",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<leader>!", stop, {
        desc = "Eval 'user/stop",
        buffer = event.buf,
      })

      vim.keymap.set("n", "<localleader>nr", reload_namespaces, {
        desc = "Eval 'user/reload-namespaces",
        buffer = event.buf,
      })
    end,
  })
end

return M
