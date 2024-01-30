local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.bb" },
    desc = "Set the filetype of .bb files",
    callback = function(event)
      vim.api.nvim_buf_set_option(event.buf, "filetype", "clojure")
    end,
  })
end

return M
