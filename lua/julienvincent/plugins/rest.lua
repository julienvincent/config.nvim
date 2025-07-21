return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http" },
    config = function()
      local kulala = require("kulala")
      local ui = require("kulala.ui")

      kulala.setup({
        default_view = "body",
        default_env = "local",
        debug = false,

        kulala_keymaps = {
          ["Show headers and body"] = {
            "<localleader>a",
            function()
              require("kulala.ui").show_headers_body()
            end,
          },
          ["Show verbose"] = {
            "<localleader>v",
            function()
              require("kulala.ui").show_verbose()
            end,
          },
        },
      })

      local function setup_keybinds(event)
        vim.keymap.set("n", "<localleader>rr", function()
          kulala.run()
        end, { desc = "Execute request under cursor", buffer = event.buf })

        vim.keymap.set("n", "<localleader>rp", function()
          kulala.replay()
        end, { desc = "Re-run the last executed request", buffer = event.buf })

        vim.keymap.set("n", "<localleader>rs", function()
          kulala.set_selected_env()
        end, { desc = "Select request environment", buffer = event.buf })

        vim.keymap.set("n", "[r", function()
          ui.show_previous()
        end, { desc = "Prev request", buffer = event.buf })

        vim.keymap.set("n", "]r", function()
          ui.show_next()
        end, { desc = "Next request", buffer = event.buf })

        vim.keymap.set("n", "[[", function()
          kulala.jump_prev()
        end, { desc = "Prev request", buffer = event.buf })

        vim.keymap.set("n", "]]", function()
          kulala.jump_next()
        end, { desc = "Next request", buffer = event.buf })

        vim.keymap.set("n", "<localleader>rf", function()
          kulala.search()
        end, { desc = "Search request history", buffer = event.buf })
      end

      vim.api.nvim_create_autocmd({ "FileType", "BufNewFile", "BufRead" }, {
        pattern = { "*.http" },
        desc = "Set the filetype of .http files",
        callback = setup_keybinds,
      })

      local filetype = vim.api.nvim_get_option_value("ft", {
        buf = 0,
      })

      if filetype == "http" then
        setup_keybinds({ buf = 0 })
      end
    end,
  },
}
