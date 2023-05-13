return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      keys = {},
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
      window = {
        mappings = {
          ["<Right>"] = function(state)
            local node = state.tree:get_node()
            if require("neo-tree.utils").is_expandable(node) then
              state.commands["toggle_node"](state)
            else
              state.commands["open"](state)
              vim.cmd("Neotree reveal")
            end
          end,

          ["<Left>"] = function(state)
            local node = state.tree:get_node()
            if require("neo-tree.utils").is_expandable(node) then
              state.commands["toggle_node"](state)
            end
          end,
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        cwd = vim.fn.getcwd(),
      },
    },
  },

  {
    "guns/vim-sexp",
    ft = { "clojure" },

    init = function()
      vim.g.sexp_filetypes = "clojure"
    end,

    dependencies = {
      "radenling/vim-dispatch-neovim",
      {
        "tpope/vim-sexp-mappings-for-regular-people",
        init = function()
          vim.g.sexp_no_word_maps = true
        end,
      },
      "tpope/vim-repeat",
    },
  },

  { "psliwka/vim-smoothie" },
}
