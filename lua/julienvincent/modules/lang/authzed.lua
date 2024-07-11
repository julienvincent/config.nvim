local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.zed" },
    desc = "Set the filetype of .zed files",
    callback = function(event)
      vim.api.nvim_set_option_value("filetype", "authzed", {
        buf = event.buf,
      })
      vim.bo.commentstring = "//%s"
    end,
  })
end

return M
