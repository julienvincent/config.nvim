return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>:",       "<cmd>Telescope commands<cr>",                  desc = "Grep" },
      { "<leader>/",       "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in buffer" },
      { "<leader>ff",      "<cmd>Telescope live_grep<cr>",                 desc = "Grep" },
      { "<leader>fc",      "<cmd>Telescope git_commits<CR>",               desc = "commits" },
      { "<leader>fs",      "<cmd>Telescope git_status<CR>",                desc = "status" },
    },
    opts = {
      pickers = {
        find_files = {
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "--ignore",
            "-u",
            "--trim",
            "--smart-case",
            "--max-columns=150",

            "--glob=!**/.git/*",
            "--glob=!**/node_modules/*",
            "--glob=!**/.next/*",
            "--glob=!**/target/*",
            "--glob=!**/.shadow-cljs/*",
            "--glob=!**/.cpcache/*",
            "--glob=!**/.cache/*",
            "--glob=!*-lock.*",
            "--glob=!*.log",
          },
        },
      },
    },
  },
}
