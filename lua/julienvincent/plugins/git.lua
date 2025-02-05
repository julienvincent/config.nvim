-- This checks if Neovim was started with "-c DiffviewOpen" in which case we
-- generally want to quit neovim when exiting DiffView.
local function opened_on_boot()
  for i = 1, #vim.v.argv do
    if vim.v.argv[i] == "-c" and vim.v.argv[i + 1] and vim.v.argv[i + 1]:match("^DiffviewOpen") then
      return true
    end
  end
  return false
end

local function close_diffview()
  if opened_on_boot() then
    vim.cmd("qa")
    return
  end

  vim.cmd.DiffviewClose()
end

return {
  { "avm99963/vim-jjdescription" },

  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
      local hunk = require("hunk")
      hunk.setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost" },
    opts = {
      signs = {
        add = { text = "❙" },
        change = { text = "❙" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "❙" },
        untracked = { text = "❙" },
      },
      attach_to_untracked = true,
      on_attach = function(buffer)
        local gs = require("gitsigns")

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function ()
          gs.nav_hunk("next")
        end, "Next Hunk")
        map("n", "[h", function ()
          gs.nav_hunk("prev")
        end, "Prev Hunk")

        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Diff Hunk")

        map("n", "<leader>gbl", gs.blame_line, "Blame Line")
        map("n", "<leader>gbb", gs.blame , "Toggle line blame")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gl", "<cmd>DiffviewFileHistory<cr>", desc = "Git log" },
    },
    cmd = { "DiffviewOpen" },
    config = function()
      local actions = require("diffview.actions")
      require("diffview").setup({
        enhanced_diff_hl = true,

        keymaps = {
          view = {
            ["q"] = close_diffview,
          },
          file_panel = {
            ["q"] = close_diffview,
            {
              "n",
              "<Right>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
            {
              "n",
              "<cr>",
              actions.focus_entry,
              { desc = "Focus the diff entry" },
            },
          },
          file_history_panel = {
            ["q"] = close_diffview,
          },
        },

        hooks = {
          diff_buf_win_enter = function()
            -- vim.opt_local.foldenable = false
          end,
        },
      })
    end,
  },
}
