local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.bb" },
    desc = "Set the filetype of .bb files",
    callback = function(event)
      vim.api.nvim_set_option_value("filetype", "clojure", {
        buf = event.buf,
      })
    end,
  })
end

return M
