return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
        },
        filetypes = {
          yaml = true,
          markdown = true,
          lua = true,
          clojure = true,
          ["."] = false,
        },
      })

      local suggestion = require("copilot.suggestion")
      local panel = require("copilot.panel")

      require("which-key").register({
        ["<C-CR>"] = { suggestion.accept, "Copilot accept" },
        ["<C-Left>"] = { suggestion.next, "Copilot prev" },
        ["<C-Right>"] = { suggestion.next, "Copilot next" },
      }, { mode = "i" })

      require("which-key").register({
        c = {
          name = "Copilot",
          p = { panel.open, "Open panel" },
        },
      }, { prefix = "<localleader>" })
    end,
  },
}
