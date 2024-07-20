return {
  -- This requires the cli tool 'yq' to be installed:
  -- https://github.com/mikefarah/yq
  {
    "topaxi/gh-actions.nvim",
    cmd = "GhActions",
    config = function()
      require("gh-actions").setup({})
    end,
  },
}
