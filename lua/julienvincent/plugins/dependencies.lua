return {
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override_by_extension = {
          ["num"] = {
            icon = "",
            color = "#A2AAAD",
            name = "Numscript",
          },
        },
      })
    end,
  },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "kkharji/sqlite.lua", lazy = true, init = function() 
      vim.g.sqlite_clip_path = "/nix/store/p7skikz70hkik6w724fxcpvga8n5nccb-sqlite-3.45.3/lib/libsqlite3.so"
  end },
}
