local get_neotree_state = function()
  local bufnr = vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()

  -- Get all the available sources in neo-tree
  for _, source in ipairs(require("neo-tree").config.sources) do
    -- Get each sources state
    local state = require("neo-tree.sources.manager").get_state(source)

    local is_open = state and state.bufnr
    local is_focused = is_open and state.bufnr == bufnr

    return {
      is_open = is_open,
      is_focused = is_focused,
    }
  end

  return {
    is_open = false,
    is_focused = false,
  }
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    keys = {
      {
        "<leader>e",
        function()
          local state = get_neotree_state()
          if state.is_focused then
            -- switch back to current buffer
          else
            if not state.is_open then
              vim.cmd.Neotree("toggle")
            end
            vim.cmd.Neotree("focus")
          end
        end,
      },
      { "<leader>k", "<cmd>:Neotree toggle<cr>" },
    },

    opts = {
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = true,
        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true,
        },
      },

      window = {
        mappings = {
          ["<space>"] = "none",

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

      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },

        icon = {
          folder_empty = "-",
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
