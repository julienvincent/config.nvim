local PREVIOUS_WIN = nil

local get_neotree_state = function()
  local bufnr = vim.api.nvim_get_current_buf()

  for _, source in ipairs(require("neo-tree").config.sources) do
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

local function toggle_neotree_focus()
  local state = get_neotree_state()
  if state.is_focused then
    if PREVIOUS_WIN then
      vim.api.nvim_set_current_win(PREVIOUS_WIN)
    end
  else
    PREVIOUS_WIN = vim.api.nvim_get_current_win()
    vim.cmd.Neotree("focus")
  end
end

local function reveal_file_in_neotree()
  local state = get_neotree_state()
  if state.is_focused then
    return
  end
  PREVIOUS_WIN = vim.api.nvim_get_current_win()
  vim.cmd.Neotree("reveal")
end

local function register_keymaps()
  require("which-key").register({
    ["<leader>"] = {
      E = {
        reveal_file_in_neotree,
        "Reveal current file in Neotree",
      },
      e = {
        toggle_neotree_focus,
        "Toggle Neotree focus",
      },
      k = {
        function()
          vim.cmd.Neotree("toggle")
        end,
        "Hide or show Neotree",
      },
    },
  })
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "3.*",
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

    config = function()
      require("neo-tree").setup({
        enable_diagnostics = false,

        -- This causes NeoTree to use the native vim.ui implementations - which in my setup are overridden
        -- by Drerssing.nvim. This allows editing in normal mode.
        use_popups_for_input = false,

        filesystem = {
          bind_to_cwd = true,
          follow_current_file = false,
          use_libuv_file_watcher = true,

          filtered_items = {
            visible = true,
          },
        },

        window = {
          width = 30,
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
            folder_empty = "~",
          },
          modified = {
            symbol = "",
          },
          name = {
            use_git_status_colors = true,
          },
          git_status = {
            symbols = {
              -- Change type
              added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "", -- this can only be used in the git_status source
              renamed = "", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },

        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", {
                link = "NeoTreeGitModified",
              })
            end,
          },
        },
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        pattern = "*",
        desc = "Refresh NeoTree git status on focus",
        callback = function()
          require("neo-tree.sources.git_status").refresh()
        end,
      })

      -- I got the inspiration for this override from:
      -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/351
      require("neo-tree.ui.inputs").confirm = function(message, callback)
        vim.ui.select({ "Yes", "No" }, {
          prompt = message,
        }, function(choice)
          callback(choice == "Yes")
        end)
      end

      register_keymaps()
    end,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
