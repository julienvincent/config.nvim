return {
  {
    "julienvincent/nvim-paredit",
    -- dir = "~/code/nvim-paredit",
    ft = { "clojure" },
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        use_default_keys = false,
        keys = {
          ["<S-Right>"] = { paredit.api.slurp_forwards, "Slurp" },
          ["<S-Left>"] = { paredit.api.barf_forwards, "Barf" },

          ["<M-Left>"] = { paredit.api.drag_element_backwards, "Drag element left" },
          ["<M-Right>"] = { paredit.api.drag_element_forwards, "Drag element right" },

          ["<M-S-Left>"] = { paredit.api.drag_form_backwards, "Drag form left" },
          ["<M-S-Right>"] = { paredit.api.drag_form_forwards, "Drag form right" },

          ["<localleader>r"] = { paredit.api.raise_element, "Raise element" },
          ["<localleader>R"] = { paredit.api.raise_form, "Raise form" },

          ["E"] = { paredit.api.move_to_next_element, "Jump to next element" },
          ["B"] = { paredit.api.move_to_prev_element, "Jump to previous element" },
        }
      })
    end
  },
}
