return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local Rule = require("nvim-autopairs.rule")
      local pairs = require("nvim-autopairs")

      pairs.setup({
        check_ts = true,
        enable_check_bracket_line = false,
      })

      pairs.get_rules("`")[1].not_filetypes = { "clojure" }
      pairs.get_rules("'")[1].not_filetypes = { "clojure", "rust" }

      -- local type_def_rule = Rule("<", ">", { "typescript", "rust" })
      --   :with_del(function(opts)
      --     -- This deletes the pair if `<` is pressed twice
      --     local line = opts.line
      --     local col = opts.col
      --     if col > 1 and line:sub(col - 1, col - 1) == "<" then
      --       return true
      --     end
      --     return false
      --   end)
      --   :with_move(function(opts)
      --     return opts.char == ">"
      --   end)
      --   :with_pair(function(opts)
      --     -- This checks if the character before the cursor is also `<`
      --     local line = opts.line
      --     local col = opts.col
      --     return not (col > 1 and line:sub(col - 1, col - 1) == "<")
      --   end)
      --
      -- pairs.add_rule(type_def_rule)

      -- pairs.add_rule(Rule("<", ">", { "typescript", "rust" }):with_move(function(opts)
      --   return opts.char == ">"
      -- end))
    end,
  },
}
