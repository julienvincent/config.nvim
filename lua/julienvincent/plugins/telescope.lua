return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in buffer" },
      { "<leader>ff", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
      { "<leader>fc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    },
    opts = {
      defaults = {
        layout_config = {
          vertical = { width = 0.9 },
        },
        layout_strategy = "vertical",
      },
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

  {
    "danielfalk/smart-open.nvim",
    -- branch = "0.2.x",
    branch = "main",
    config = function()
      require("telescope").load_extension("smart_open")
    end,
    keys = {
      {
        "<leader><space>",
        function()
          require("telescope").extensions.smart_open.smart_open({
            cwd_only = true,
            match_algorithm = "fzy",
            filename_first = false,
          })
        end,
        desc = "Find files",
      },
    },
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
  },
}
