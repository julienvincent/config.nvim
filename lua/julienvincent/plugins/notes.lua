return {
  {
    "backdround/global-note.nvim",
    keys = { "<leader>N" },
    config = function()
      local global_note = require("global-note")
      global_note.setup({
        post_open = function(buffer_id)
          vim.keymap.set("n", "q", global_note.toggle_note, {
            desc = "Close note",
            buffer = buffer_id,
          })
        end,
      })

      vim.keymap.set("n", "<leader>N", global_note.toggle_note, {
        desc = "Toggle global note",
      })
    end,
  },
}
