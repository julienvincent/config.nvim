return {
  { "avm99963/vim-jjdescription" },

  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
      local hunk = require("hunk")
      hunk.setup()
    end,
  },
}
