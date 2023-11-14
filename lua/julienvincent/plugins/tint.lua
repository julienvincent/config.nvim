return {
  {
    "levouh/tint.nvim",
    lazy = true,
    config = function()
      require("tint").setup({
        tint = -40,
        -- window_ignore_function = function(winid)
        --   local bufid = vim.api.nvim_win_get_buf(winid)
        --   local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
        --   local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
        --
        --   local name = vim.api.nvim_buf_get_name(bufid)
        --   local is_neotree = name:find("neo%-tree")
        --
        --   -- Do not tint `terminal` or floating windows, tint everything else
        --   return buftype == "terminal" or floating or is_neotree
        -- end,
      })
    end,
  },
}
