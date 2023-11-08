return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local pairs = require("nvim-autopairs")

      pairs.setup({
        check_ts = true,
        enable_check_bracket_line = false,
      })

      pairs.get_rules("`")[1].not_filetypes = { "clojure" }
      pairs.get_rules("'")[1].not_filetypes = { "clojure" }
    end,
  },
}
