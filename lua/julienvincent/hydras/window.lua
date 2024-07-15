return {
  create = function()
    local Hydra = require("hydra")
    Hydra({
      name = "Window Manager",
      mode = "n",
      config = {
        invoke_on_body = true,
        hint = {
          type = "window",
          float_opts = {
            border = "rounded",
          },
        },
      },
      body = "<leader>w",
      heads = {
        { "w", "<C-W>p", { desc = "Switch to other window", exit = true } },

        { "d", "<C-W>c", { desc = "Close window" } },
        { "v", "<C-W>v", { desc = "Split window right" } },
        { "h", "<C-W>s", { desc = "Split window below" } },

        { "<S-Right>", "<C-W>v", { desc = "Split window right" } },
        { "<S-Down>", "<C-W>s", { desc = "Split window below" } },

        { "s", "<C-W>x", { desc = "Swap window with next" } },

        { "=", "<C-W>=", { desc = "Equalize windows" } },
        { ">", "10<C-w>>", { desc = "resize →" } },
        { "<", "10<C-w><", { desc = "resize ←" } },
        { "+", "10<C-w>+", { desc = "resize ↑" } },
        { "-", "10<C-w>-", { desc = "resize ↓" } },
        -- This is just an alias for `-` incase it gets mistyped (no S- modifier)
        { "_", "10<C-w>-", { desc = false } },

        { "<Left>", "<C-w>h", { desc = "Go to left window" } },
        { "<Right>", "<C-w>l", { desc = "Go to right window" } },
        { "<Up>", "<C-w>k", { desc = "Go to upper window" } },
        { "<Down>", "<C-w>j", { desc = "Go to lower window" } },

        { "<Esc>", nil, { desc = "Exit", exit = true } },
        { "q", nil, { desc = "Exit", exit = true } },
      },
    })
  end,
}
