return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http" },
    config = function()
      local kulala = require("kulala")

      kulala.setup({
        default_view = "body",
        default_env = "local",
        debug = false,
      })

      local function setup_keybinds(event)
        vim.keymap.set("n", "<localleader>rr", function()
          kulala.run()
        end, { desc = "Execute request under cursor", buffer = event.buf })

        vim.keymap.set("n", "<localleader>rs", function()
          kulala.set_selected_env()
        end, { desc = "Select request environment", buffer = event.buf })
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
