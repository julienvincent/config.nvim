vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})
