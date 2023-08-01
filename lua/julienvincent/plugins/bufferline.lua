local tab_name = require("julienvincent.behaviours.tab-name")

return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "tabs",
        themable = true,
        name_formatter = function(buf)
          local tabnr = vim.api.nvim_tabpage_get_number(buf.tabnr)
          return tab_name.get_name(tabnr)
        end,
        separator_style = "thin",
        always_show_bufferline = false,
      },
    },
  },
}
