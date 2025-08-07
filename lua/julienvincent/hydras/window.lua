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

        { "d", "<C-W>c", { desc = "Close window", exit = true } },
        { "D", "<C-W>c", { desc = "Close window" } },
        { "v", "<Cmd>vnew<Cr>", { desc = "Split window right" } },
        { "h", "<Cmd>new<Cr>", { desc = "Split window below" } },

        { "<S-Right>", "<C-W>x<C-w>l", { desc = "Swap window with right" } },
        { "<S-Left>", "<C-w>h<C-w>x", { desc = "Swap with left" } },
        { "<S-Up>", "<C-w>x<C-w>k", { desc = "Swap with above" } },
        { "<S-Down>", "<C-w>j<C-w>x", { desc = "Swap with below" } },

        { "s", "<Cmd>vnew<Cr>", { desc = "Split window right", exit = true } },
        { "S", "<Cmd>new<Cr>", { desc = "Split window below", exit = true } },

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
