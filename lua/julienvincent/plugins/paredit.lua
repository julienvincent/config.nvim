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

          ["<S-H>"] = { paredit.api.slurp_backwards, "Slurp backwards" },
          ["<S-L>"] = { paredit.api.barf_backwards, "Barf backwards" },

          ["<M-Left>"] = { paredit.api.drag_element_backwards, "Drag element left" },
          ["<M-Right>"] = { paredit.api.drag_element_forwards, "Drag element right" },

          ["<M-S-Left>"] = { paredit.api.drag_form_backwards, "Drag form left" },
          ["<M-S-Right>"] = { paredit.api.drag_form_forwards, "Drag form right" },

          ["<localleader>r"] = { paredit.api.raise_element, "Raise element" },
          ["<localleader>R"] = { paredit.api.raise_form, "Raise form" },

          ["E"] = {
            paredit.api.move_to_next_element,
            "Jump to next element",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },
          ["B"] = {
            paredit.api.move_to_prev_element,
            "Jump to previous element",
            repeatable = false,
            mode = { "n", "x", "o", "v" },
          },

          ["af"] = {
            paredit.api.select_around_form,
            "Around form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["if"] = {
            paredit.api.select_in_form,
            "In form",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["ae"] = {
            paredit.api.select_element,
            "Around element",
            repeatable = false,
            mode = { "o", "v" },
          },
          ["ie"] = {
            paredit.api.select_element,
            "Element",
            repeatable = false,
            mode = { "o", "v" },
          },
        },
      })
    end,
  },
}
