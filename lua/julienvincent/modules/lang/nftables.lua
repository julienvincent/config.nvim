local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.nft" },
    desc = "Set the filetype of .nft files",
    callback = function(event)
      vim.api.nvim_set_option_value("filetype", "nftables", {
        buf = event.buf,
      })
      vim.bo.commentstring = "#%s"
    end,
  })
end

return M
