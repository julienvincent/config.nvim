return {
  {
    "guns/vim-sexp",
    ft = { "clojure" },

    init = function()
      vim.g.sexp_filetypes = "clojure"
      vim.g.sexp_enable_insert_mode_mappings = 0
    end,

    dependencies = {
      "radenling/vim-dispatch-neovim",
      "tpope/vim-sexp-mappings-for-regular-people",
      "tpope/vim-repeat",
    },
  },

  { "radenling/vim-dispatch-neovim" },
  {
    "tpope/vim-sexp-mappings-for-regular-people",
    init = function()
      vim.g.sexp_no_word_maps = true
    end,
  },
  { "tpope/vim-repeat" },
}
