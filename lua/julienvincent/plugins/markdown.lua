return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "mdx" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g["mkdp_auto_close"] = 0
    end,
  },
}
