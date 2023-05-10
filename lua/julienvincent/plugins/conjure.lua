return {
  {
    "Olical/conjure",
    ft = { "clojure" },
    keys = require("julienvincent.lang.clojure.keymaps"),
    init = function()
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
      vim.g["conjure#log#hud#enabled"] = false
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
    end,
    config = function()
      local wk = require("which-key")

      local function connect_cmd()
        vim.api.nvim_feedkeys(":ConjureConnect localhost:", "n", false)
      end

      local nrepl = require("julienvincent.lang.clojure.nrepl")

      wk.register({
        c = {
          name = "NREPL Connect",
          cond = vim.bo.filetype == "clojure",
          f = {
            nrepl.find_repls,
            "Find and connect to running repls",
          },
          c = { connect_cmd, "Connect via port" },
          s = {
            nrepl.switch_active_repl,
            "Switch repl session",
          },
          n = {
            function()
              vim.ui.input({ prompt = "Name: " }, function(name)
                nrepl.create_new_repl_session(name)
                nrepl.find_repls()
              end)
            end,
            "Create new nrepl session",
          },
          l = {
            function()
              vim.cmd("ConjureLogCloseVisible")
              vim.cmd("ConjureLogVSplit")
            end,
            "Open the repl log buffer",
          },
        },
      }, {
        prefix = "<leader>",
      })
    end,
  },
}
