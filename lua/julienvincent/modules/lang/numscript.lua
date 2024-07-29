local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.num" },
    desc = "Set the filetype of .num files",
    callback = function(event)
      vim.api.nvim_set_option_value("filetype", "numscript", {
        buf = event.buf,
      })
      vim.bo.commentstring = "#%s"
    end,
  })
end

return M
