return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
        "hide",

        winopts = {
          preview = {
            layout = "vertical",
            delay = 0,
            vertical = "up:45%",
          },
        },

        fzf_opts = {
          ["--cycle"] = true,
          ["--pointer"] = "❯",
          ["--marker"] = "❯",
          ["--layout"] = "default",
        },

        fzf_colors = {
          ["gutter"] = "-1",
        },

        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
            ["alt-a"] = "toggle",
            ["alt-A"] = "toggle-all",
          },
        },
      })

      vim.keymap.set("n", "<leader>ff", function()
        fzf.grep_project({
          keymap = {
            fzf = {
              ["ctrl-q"] = "select-all+accept",
              ["alt-a"] = "toggle",
            },
          },
        })
      end, { silent = true, desc = "Find" })

      vim.keymap.set("n", "<leader>fr", fzf.resume, {
        silent = true,
        desc = "Find",
      })

      vim.keymap.set("n", "<leader>/", function()
        fzf.grep_curbuf()
      end, { silent = true, desc = "Find" })
    end,
  },
}
