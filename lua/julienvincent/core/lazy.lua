-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

-- We have to set the leader keys here for lazy.nvim to work
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

lazy.setup("julienvincent.plugins", {
  change_detection = {
    enabled = false,
  },
})

require("julienvincent.helpers.keys").map("n", "<leader>LL", lazy.show, "Show Lazy")
