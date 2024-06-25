return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({
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
          ["--layout"] = "default",
        },

        fzf_colors = {
          ["gutter"] = "-1",
        },
      })

      vim.keymap.set("n", "<leader><space>", function()
        fzf.files({
          prompt = "❯ ",
          header = false,
          cwd_prompt = false,
          ignore_current_file = true,

          winopts = {
            height = 0.60,
            width = 0.50,
            row = 0.33,
            col = 0.33,
          },
        })
      end, { silent = true, desc = "Find files" })

      vim.keymap.set("n", "<leader>ff", function()
        fzf.grep_project()
      end, { silent = true, desc = "Find" })

      vim.keymap.set("n", "<leader>fr", function()
        fzf.grep_project({ resume = true })
      end, { silent = true, desc = "Find" })

      vim.keymap.set("n", "<leader>/", function()
        fzf.grep_curbuf()
      end, { silent = true, desc = "Find" })
    end,
  },
}
