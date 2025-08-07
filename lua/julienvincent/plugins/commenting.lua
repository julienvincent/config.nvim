return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          mdx = {
            __default = "{/* %s */}",
            __multiline = "{/* %s */}",
          },
        },
      })
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      local comment_context = require("ts_context_commentstring.integrations.comment_nvim")
      require("Comment").setup({
        pre_hook = comment_context.create_pre_hook(),
      })
    end,
  },
}
