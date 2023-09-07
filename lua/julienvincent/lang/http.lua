local map = require("julienvincent.helpers.keys").map

local M = {}

function M.select_env()
  vim.ui.input({
    prompt = "Select env file",
    default = ".env.",
    kind = "center",
  }, function(value)
    if not value then
      return
    end

    vim.cmd.RestSelectEnv(value)
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.http" },
    desc = "Set the filetype of .http files",
    callback = function(event)
      vim.api.nvim_buf_set_option(event.buf, "filetype", "http")
      vim.bo.commentstring = "#%s"

      map("n", "<localleader>rr", "<Plug>RestNvim<Cr>", { desc = "Run HTTP request", buffer = event.buf })
      map("n", "<localleader>rp", "<Plug>RestNvimPreview<Cr>", { desc = "Preview HTTP request", buffer = event.buf })
      map("n", "<localleader>rl", "<Plug>RestNvimLast<Cr>", { desc = "Rerun last request", buffer = event.buf })
      map("n", "<localleader>rs", M.select_env, { desc = "Select env", buffer = event.buf })
    end,
  })
end

return M
