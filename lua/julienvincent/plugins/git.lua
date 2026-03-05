-- This checks if Neovim was started with "-c DiffviewOpen" in which case we
-- generally want to quit neovim when exiting DiffView.
local function opened_on_boot()
  for i = 1, #vim.v.argv do
    if vim.v.argv[i] == "-c" and vim.v.argv[i + 1] and vim.v.argv[i + 1]:match("^Diffview") then
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
  { "rafikdraoui/jj-diffconflicts" },

  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
      local hunk = require("hunk")
      hunk.setup({
        keys = {
          diff = {
            prev_hunk = { "<S-Left>" },
            next_hunk = { "<S-Right>" },

            toggle_line = { "s" },
            toggle_line_pair = { "a" },
          },
        },
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost" },
    opts = {
      signs = {
        add = { text = "|" },
        change = { text = "|" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "|" },
        untracked = { text = "|" },
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
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
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

            {
              "n",
              "<Left>",
              actions.select_entry,
              { desc = "Open the diff for the selected entry" },
            },
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
        },

        hooks = {
          diff_buf_win_enter = function(bufnr, _, ctx)
            -- This little hack is a quality-of-life improvement which shrinks
            -- the 'left' window when the file is empty (i.e we are looking at
            -- an ADDED diff).
            --
            -- If automatically equalizes the windows again when opening a diff
            -- with content on the left.
            --
            -- ctx.symbol == "a" when we are operating on the 'left' buffer,
            -- and the bufname == "diffview://null" when the left side has no
            -- content.
            if ctx.symbol == "a" then
              local bufname = vim.api.nvim_buf_get_name(bufnr)
              local is_empty = bufname == "diffview://null"
              if is_empty then
                local win = vim.fn.bufwinid(bufnr)
                if win ~= -1 then
                  vim.api.nvim_win_set_width(win, 1)
                end
              else
                vim.cmd("wincmd =")
              end
            end
          end,
        },
      })
    end,
  },
}
