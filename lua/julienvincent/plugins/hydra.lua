-- Note that the original project located at https://github.com/anuvyklack/hydra.nvim is now unmaintained
-- and has been forked. The project listed here is the fork.
--
-- See the issue on the original project:
-- https://github.com/anuvyklack/hydra.nvim/issues/101
--
-- This fork is needed because there are several issues with the original, especially on 0.10+. For example
-- on neovim 0.10+ the floating hint seems to completely break buffers. This fork fixes that
return {
  {
    "nvimtools/hydra.nvim",
    event = "VeryLazy",
    config = function()
      require("julienvincent.hydras.window").create()
      require("julienvincent.hydras.portal").create()
    end,
  },
}
