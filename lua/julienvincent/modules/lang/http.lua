local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.http" },
    desc = "Set the filetype of .http files",
    callback = function(event)
      vim.api.nvim_set_option_value("filetype", "http", {
        buf = event.buf,
      })
      vim.bo.commentstring = "#%s"
    end,
  })
end

return M
