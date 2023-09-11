return {
  {
    "julienvincent/nvim-paredit",
    -- dir = "~/code/nvim-paredit",
    ft = { "clojure" },
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        indent = {
          enabled = true,
        },

        keys = {
          [">)"] = false,
          [">("] = false,
          ["<)"] = false,
          ["<("] = false,
          [">e"] = false,
          ["<e"] = false,
          [">f"] = false,
          ["<f"] = false,
          ["<localleader>o"] = false,
          ["<localleader>O"] = false,

          ["<S-Right>"] = { paredit.api.slurp_forwards, "Slurp" },
          ["<S-Left>"] = { paredit.api.barf_forwards, "Barf" },

          ["<S-H>"] = { paredit.api.slurp_backwards, "Slurp backwards" },
          ["<S-L>"] = { paredit.api.barf_backwards, "Barf backwards" },

          ["<M-Left>"] = { paredit.api.drag_element_backwards, "Drag element left" },
          ["<M-Right>"] = { paredit.api.drag_element_forwards, "Drag element right" },

          ["<M-S-Left>"] = { paredit.api.drag_form_backwards, "Drag form left" },
          ["<M-S-Right>"] = { paredit.api.drag_form_forwards, "Drag form right" },

          ["<localleader>r"] = { paredit.api.raise_element, "Raise element" },
          ["<localleader>R"] = { paredit.api.raise_form, "Raise form" },
        },
      })
    end,
  },
}
