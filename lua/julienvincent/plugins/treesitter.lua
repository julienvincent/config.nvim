return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },

    -- nvim-treesitter has changed it's capture groups after this version. Updating requires colorschemes to support
    -- the new capture group names. Confirm this before changing this version.
    version = "v0.9.2",

    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        ensure_installed = {
          "authzed",
          "bash",
          "html",
          "javascript",
          "http",
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
          "graphql",
          "fennel",
          "clojure",
          "commonlisp",
          "rust",
          "go",
        },
        autotag = {
          enable = true,
          filetypes = { "html", "xml", "typescriptreact" },
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
      })
    end,
  },

  {
    "https://github.com/windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
  },
}
