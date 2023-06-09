return {
  {
    dir = "~/code/nvim-paredit",
    ft = { "clojure" },
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        use_default_keys = false,
        keys = {
          ["<S-Right>"] = { paredit.api.slurpForwards, "Slurp" },
          ["<S-Left>"] = { paredit.api.barfForwards, "Barf" },

          ["<M-Left>"] = { paredit.api.dragElementBackwards, "Drag element left" },
          ["<M-Right>"] = { paredit.api.dragElementForwards, "Drag element right" },

          ["<M-S-Left>"] = { paredit.api.dragFormBackwards, "Drag form left" },
          ["<M-S-Right>"] = { paredit.api.dragFormForwards, "Drag form right" },

          ["<localleader>r"] = { paredit.api.raiseElement, "Raise element" },
          ["<localleader>R"] = { paredit.api.raiseForm, "Raise form" },

          ["E"] = { paredit.api.moveToNextElement, "Jump to next element" },
          ["B"] = { paredit.api.moveToPrevElement, "Jump to previous element" },
        }
      })
    end
  },
}
