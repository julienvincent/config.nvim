local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.nft" },
    desc = "Set the filetype of .nft files",
    callback = function(event)
      vim.api.nvim_buf_set_option(event.buf, "filetype", "nftables")
      vim.bo.commentstring = "#%s"
    end,
  })
end

return M
