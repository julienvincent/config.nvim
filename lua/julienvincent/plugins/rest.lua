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

      vim.api.nvim_create_autocmd({ "FileType", "BufNewFile", "BufRead" }, {
        pattern = { "*.http" },
        desc = "Set the filetype of .http files",
        callback = function()
          vim.keymap.set("n", "<localleader>rr", function()
            kulala.run()
          end, { desc = "Execute request under cursor" })

          vim.keymap.set("n", "<localleader>rs", function()
            kulala.set_selected_env()
          end, { desc = "Select request environment" })
        end,
      })
    end,
  },
}
