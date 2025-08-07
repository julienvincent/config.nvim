return {
  {
    "dmtrKovalenko/fff.nvim",
    -- This is really just here to ensure it starts after the file-tree (which
    -- sets the cwd)
    event = "VeryLazy",
    build = "cargo build --release",
    config = function()
      local fff = require("fff")

      fff.setup({
        layout = {
          width = 0.6,
          height = 0.7,
        },
        prompt = "❯ ",

        preview = {
          enabled = false,
        },
      })

      vim.keymap.set("n", "<leader><space>", function()
        fff.find_files()
      end, {
        desc = "Open file picker",
      })
    end,
  },
}
