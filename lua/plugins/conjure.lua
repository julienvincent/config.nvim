return {
  "Olical/conjure",
  keys = {
    {
      "<leader>§",
      function()
        local eval = require("conjure.eval")
        eval["eval-str"]({
          code = "(do (ns user) (reset) nil)",
          origin = "custom_command",
        })
      end,
    },
  },
}
