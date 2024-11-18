return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,

    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        ignore_install = {},
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "nim",
          "cpp",
          "bash",
          "html",
          "javascript",
          "http",
          "json",
          "csv",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "kdl",
          "mermaid",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          "graphql",
          "fennel",
          "sql",
          "commonlisp",
          "rust",
          "go",
        },
      })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.clojure = {
        install_info = {
          url = "https://github.com/julienvincent/tree-sitter-clojure",
          revision = "5cf3c430a3d98cfd2191b420caee1b4b36e5e917",
          files = { "src/parser.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
      }

      parser_config.spicedb = {
        install_info = {
          url = "https://github.com/authzed/tree-sitter-spicedb",
          files = { "src/parser.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
          branch = "main",
        },
        filetype = "authzed",
      }

      parser_config.numscript = {
        install_info = {
          url = "https://github.com/julienvincent/tree-sitter-numscript",
          files = { "src/parser.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
          branch = "master",
        },
        filetype = "numscript",
      }
    end,
  },

  {
    "julienvincent/tree-sitter-numscript",
  },

  {
    "https://github.com/windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("treesitter-context").setup({
        enable = false,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        separator = "-",
      })

      vim.keymap.set("n", "<localleader>C", "<Cmd>TSContextToggle<Cr>", {
        desc = "Toggle treesitter context",
      })
    end,
  },
}
