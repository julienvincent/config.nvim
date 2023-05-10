return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      keys = {},
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
}
