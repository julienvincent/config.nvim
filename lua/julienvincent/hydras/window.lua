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
          border = "double",
        },
        on_enter = function()
          local tint = require("tint")

          tint.enable()

          local wins = vim.api.nvim_list_wins()
          local current_win = vim.api.nvim_get_current_win()
          for _, win in ipairs(wins) do
            if win ~= current_win then
              tint.tint(win)
            end
          end
        end,

        on_exit = function()
          local tint = require("tint")

          local wins = vim.api.nvim_list_wins()
          for _, win in ipairs(wins) do
            tint.untint(win)
          end

          tint.disable()
        end,
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
