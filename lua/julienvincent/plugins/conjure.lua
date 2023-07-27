return {
  {
    "Olical/conjure",
    ft = { "clojure", "lua" },
    keys = require("julienvincent.lang.clojure.keymaps"),
    init = function()
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#highlight#group"] = "CurrentWord"
      vim.g["conjure#highlight#timeout"] = 200
      vim.g["conjure#eval#inline#highlight"] = "CurrentWord"

      vim.g['conjure#extract#tree_sitter#enabled'] = true

      vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
      vim.g["conjure#log#hud#enabled"] = false
      vim.g["conjure#log#wrap"] = true
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false

      vim.g["conjure#mapping#doc_word"] = false

      vim.g["conjure#client#clojure#nrepl#mapping#disconnect"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#connect_port_file"] = false

      vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_fresh"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_close"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_close_all"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_list"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_next"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_prev"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#session_select"] = false

      vim.g["conjure#client#clojure#nrepl#mapping#refresh_changed"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#refresh_all"] = false
      vim.g["conjure#client#clojure#nrepl#mapping#refresh_clear"] = false

      vim.g["conjure#log#jump_to_latest#cursor_scroll_position"] = "none"
    end,
    config = function()
      local wk = require("which-key")

      local nrepl = require("julienvincent.lang.clojure.nrepl")

      wk.register({
        c = {
          name = "Repl Connection",

          f = {
            nrepl.find_repls,
            "Find and connect to running repls",
          },
          c = { require("conjure.client.clojure.nrepl.action")["connect-port-file"], "Connect via port file" },
          d = { require("conjure.client.clojure.nrepl.server")["disconnect"], "Disconnect" },
          p = { nrepl.direct_connect, "Connect via port" },

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
