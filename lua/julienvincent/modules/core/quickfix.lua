local M = {}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Override the iskeyword opt for some languages",
    group = vim.api.nvim_create_augroup("CoreQuickFix", { clear = true }),
    pattern = { "qf" },
    callback = function(event)
      vim.keymap.set("n", "q", "<Cmd>close<Cr>", {
        buffer = event.buf,
        silent = true,
      })

      vim.keymap.set("n", "<Right>", "<Cr><C-w>p", {
        buffer = event.buf,
      })
    end,
  })

  vim.keymap.set("n", "<leader>qn", "<Cmd>cnext<Cr>", { desc = "Quickfix next" })
  vim.keymap.set("n", "<leader>qp", "<Cmd>cprevious<Cr>", { desc = "Quickfix previous" })
  vim.keymap.set("n", "<leader>qo", "<Cmd>:botright cwindow<Cr>", { desc = "Open quickfix window" })
end

return M
