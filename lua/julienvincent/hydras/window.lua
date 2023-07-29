return {
  create = function()
    local Hydra = require("hydra")
    Hydra({
      name = "Window Manager",
      mode = "n",
      config = {
        color = "amaranth",
        invoke_on_body = true,
      },
      body = "<leader>w",
      heads = {
        { "w", "<C-W>p", { desc = "Switch to other window", exit = true } },
        { "d", "<C-W>c", { desc = "Close window", exit = true } },
        { "v", "<C-W>v", { desc = "Split window right", exit = true } },
        { "h", "<C-W>s", { desc = "Split window below", exit = true } },

        { ">", "5<C-w>>", { desc = "resize →" } },
        { "<", "5<C-w><", { desc = "resize ←" } },

        { "<Left>", "<C-w>h", { desc = "Go to left window" } },
        { "<Right>", "<C-w>l", { desc = "Go to right window" } },
        { "<Up>", "<C-w>k", { desc = "Go to upper window" } },
        { "<Down>", "<C-w>j", { desc = "Go to lower window" } },

        { "<Esc>", nil, { desc = "Exit", exit = true } },
      },
    })
  end,
}