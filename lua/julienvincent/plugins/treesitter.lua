return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      context_commentstring = { enable = true, enable_autocmd = false },
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "mermaid",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "fennel",
        "clojure",
        "commonlisp",
        "rust",
        "go",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },

    config = function(_, opts)
      -- Configure treesitter highlights for authzed .zed schema files
      --
      -- See https://github.com/mleonidas/tree-sitter-authzed
      --
      -- This also has:
      -- - A related auto-command in julienvincent.core.autocmds
      -- - A highlights.scm file in ~/.config/nvim/queries/authzed/highlights.scm
      --
      -- If the above linked repo ever gets packaged better all of this can be removed
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.authzed = {
        install_info = {
          url = "https://github.com/mleonidas/tree-sitter-authzed",
          files = { "src/parser.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
          revision = "44200686802dadf8691ff805068b7842a4afdaec"
        },
        filetype = "authzed",
      }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/playground",
    event = { "BufReadPost", "BufNewFile" },
  },
}
