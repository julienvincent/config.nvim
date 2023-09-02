local keymaps = {
  {
    "<leader>§",
    function()
      local eval = require("julienvincent.lang.clojure.eval").eval
      eval("user", "(do (tap> (reset)))")
    end,
    desc = "user/reset",
  },
  {
    "<leader>*",
    function()
      local eval = require("julienvincent.lang.clojure.eval").eval
      eval("user", "(do (require '[clojure.pprint :as pprint]) (pprint/pprint *e) (tap> *e))")
    end,
    desc = "Eval last error",
  },
}

return {
  {
    "Olical/conjure",
    version = "^4.47.0",
    ft = { "clojure", "lua" },
    keys = keymaps,
    init = function()
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#highlight#group"] = "CurrentWord"
      vim.g["conjure#highlight#timeout"] = 200
      vim.g["conjure#eval#inline#highlight"] = "CurrentWord"

      vim.g["conjure#extract#tree_sitter#enabled"] = true

      vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
      vim.g["conjure#log#hud#enabled"] = false
      vim.g["conjure#log#wrap"] = true
      vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
      vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = false

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
      local action = require("conjure.client.clojure.nrepl.action")
      local server = require("conjure.client.clojure.nrepl.server")

      wk.register({
        c = {
          name = "Repl Connection",

          f = {
            nrepl.find_repls,
            "Find and connect to running repls",
          },
          c = { action["connect-port-file"], "Connect via port file" },
          d = { server["disconnect"], "Disconnect" },
          p = { nrepl.direct_connect, "Connect via port" },

          l = {
            function()
              vim.cmd("ConjureLogToggle")
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-W>p", true, true, true), "n", true)
            end,
            "Open the repl log buffer",
          },
        },
      }, {
        prefix = "<leader>",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "clojure",
        callback = function(event)
          wk.register({
            e = {
              name = "Eval",
            },

            n = {
              name = "Clojure Namespace",

              r = { action["refresh-changed"], "Refresh changed namespaces" },
              R = { action["refresh-all"], "Refresh all namespaces" },
            },
          }, {
            prefix = "<localleader>",
            buffer = event.buf,
          })
        end,
      })

      vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "conjure-log-*",
        desc = "Disable diagnostics in conjure log buffer",
        callback = function(event)
          vim.diagnostic.disable(event.buf)
        end,
      })
    end,
  },
}
