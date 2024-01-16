return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      {
        "<leader>u",
        function()
          vim.cmd.UndotreeToggle()
        end,
        desc = "Toggle UndoTree",
      },
    },
    init = function()
      vim.g["undotree_WindowLayout"] = 3
      vim.g["undotree_SplitWidth"] = 60
      vim.g["undotree_SetFocusWhenToggle"] = 1

      vim.api.nvim_create_autocmd("FileType", {
        desc = "Add custom keybindings for UndoTree",
        pattern = { "undotree" },
        callback = function(event)
          vim.keymap.set("n", "<S-Right>", "<Plug>UndotreePreviousState<Cr>", {
            buffer = event.buf,
            silent = true,
          })

          vim.keymap.set("n", "<S-Left>", "<Plug>UndotreeNextState<Cr>", {
            buffer = event.buf,
            silent = true,
          })
        end,
      })
    end,
  },
}
