return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "tabs",
        themable = true,
        name_formatter = function(buf)
          -- return buf.path:match("/([^/]+)$")
        end,
        separator_style = "thin",
        always_show_bufferline = false,
      },
    },
  },
}
