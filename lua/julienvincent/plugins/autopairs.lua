return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local pairs = require("nvim-autopairs")

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      pairs.setup({
        check_ts = true,
        enable_check_bracket_line = false,
      })

      pairs.get_rules("`")[1].not_filetypes = { "clojure" }
      pairs.get_rules("'")[1].not_filetypes = { "clojure", "rust" }

      pairs.add_rules({
        Rule("```", "```", { "mdx" }):with_pair(cond.not_before_char("`", 3)),
        Rule("```.*$", "```", { "mdx" }):only_cr():use_regex(true),
      })
    end,
  },
}
