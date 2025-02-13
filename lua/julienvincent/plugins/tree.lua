local function get_git_changed_files_absolute()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return {}
  end
  local git_root = handle:read("*a"):gsub("%s+$", "")
  handle:close()

  if git_root == "" then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return {}
  end

  handle = io.popen("git status --porcelain 2>/dev/null")
  if not handle then
    return {}
  end
  local git_status = handle:read("*a")
  handle:close()

  local files = {}
  for line in git_status:gmatch("[^\r\n]+") do
    local file = line:match("^.. (.+)$")
    if file then
      if file:match(" -> ") then
        file = file:match(" -> (.+)$")
      end
      table.insert(files, git_root .. "/" .. file)
    end
  end

  return files
end

local function reveal_changes_in_tree()
  local api = require("nvim-tree.api")
  local files = get_git_changed_files_absolute()
  for _, file in ipairs(files) do
    api.tree.find_file({
      buf = file,
      focus = false,
    })
  end
end

local function override_highlights()
  vim.api.nvim_set_hl(0, "NvimTreeGitFileDeletedHL", {
    link = "Red",
  })

  vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", {
    link = "Blue",
  })

  vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", {
    link = "Green",
  })

  vim.api.nvim_set_hl(0, "NvimTreeGitFolderNewHL", {
    link = "NvimTreeGitFileDirtyHL",
  })

  vim.api.nvim_set_hl(0, "NvimTreeCopiedHL", {
    sp = "#E9B143",
    underline = true,
  })

  vim.api.nvim_set_hl(0, "NvimTreeCutHL", {
    sp = "#FFC0B9",
    strikethrough = true,
  })
end

local function expand_or_preview_node()
  local api = require("nvim-tree.api")

  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  if node.type == "directory" then
    if not node.open then
      api.node.open.preview()
    end

    if #node.nodes > 0 then
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, 0 })
    end

    return
  end

  api.node.open.preview()
end

local function collapse_node_or_parent()
  local api = require("nvim-tree.api")

  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  if node.type == "directory" then
    if node.open then
      return api.node.open.edit()
    end

    return api.node.navigate.parent_close()
  end

  api.node.navigate.parent_close()
end

local function expand_all_below()
  local api = require("nvim-tree.api")

  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end

  if node.type ~= "directory" then
    return
  end

  api.tree.expand_all(node)
end

local WIDTH_MODE = "fixed"
local function toggle_window_width_mode()
  local api = require("nvim-tree.api")

  if WIDTH_MODE == "fixed" then
    WIDTH_MODE = "dynamic"
    api.tree.resize({
      width = {},
    })
    api.tree.reload()
  else
    WIDTH_MODE = "fixed"
    api.tree.resize({
      width = 30,
    })
  end
end

local PREV_WINDOW = nil

local function focus_tree()
  local api = require("nvim-tree.api")

  if api.tree.is_tree_buf(0) then
    if PREV_WINDOW then
      vim.api.nvim_set_current_win(PREV_WINDOW)
    end
  else
    PREV_WINDOW = vim.api.nvim_get_current_win()
    api.tree.open()
  end
end

local function reveal_file_in_tree()
  local api = require("nvim-tree.api")

  if api.tree.is_tree_buf(0) then
    return
  end

  PREV_WINDOW = vim.api.nvim_get_current_win()
  api.tree.find_file({
    open = true,
    focus = true,
  })
end

return {
  {
    "https://github.com/nvim-tree/nvim-tree.lua",

    config = function()
      local api = require("nvim-tree.api")

      require("nvim-tree").setup({
        view = {
          signcolumn = "no",
        },

        modified = {
          enable = true,
        },

        filters = {
          enable = false,
        },

        renderer = {
          root_folder_label = ":~:s?$?/",
          highlight_git = "name",
          highlight_modified = "icon",
          icons = {
            show = {
              git = false,
              diagnostics = false,
              modified = true,
            },
          },
        },

        actions = {
          expand_all = {
            exclude = {
              ".git",
              "target",
              "node_modules",
              "dist",
              ".cache",
              ".clj-kondo",
              ".lsp",
              ".cpcache",
            },
          },
        },

        select_prompts = true,

        ui = {
          confirm = {
            default_yes = true,
          },
        },

        on_attach = function(bufnr)
          override_highlights()

          local function opts(desc)
            return {
              desc = "nvim-tree: " .. desc,
              buffer = bufnr,
              noremap = true,
              silent = true,
              nowait = true,
            }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set("n", "<Right>", expand_or_preview_node, opts("Preview Node"))
          vim.keymap.set("n", "<Left>", collapse_node_or_parent, opts("Collapse Node"))
          vim.keymap.set("n", "<S-Left>", collapse_node_or_parent, opts("Collapse Node"))
          vim.keymap.set("n", "<S-Right>", expand_all_below, opts("Expand all"))
          vim.keymap.set("n", "<leader>go", reveal_changes_in_tree, opts("Reveal Changes"))

          vim.keymap.set("n", "e", toggle_window_width_mode, opts("Toggle window width"))
        end,
      })

      vim.keymap.set("n", "<leader>k", "<Cmd>NvimTreeToggle<Cr>", { desc = "Toggle tree" })
      vim.keymap.set("n", "<leader>e", focus_tree, { desc = "Focus tree" })
      vim.keymap.set("n", "<leader>E", reveal_file_in_tree, { desc = "Open current buf in tree" })
    end,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
