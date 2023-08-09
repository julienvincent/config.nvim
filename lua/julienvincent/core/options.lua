local opts = {
  conceallevel = 0,
  cursorline = true,
  termguicolors = true,
  mouse = "a",
  winminwidth = 5,

  swapfile = false,
  undofile = true,
  undolevels = 10000,

  laststatus = 0,

  wildmode = "longest:full,full",
  inccommand = "nosplit",
  timeoutlen = 300,
  splitbelow = true,
  splitright = true,

  number = true,
  relativenumber = false,
  showmode = false,
  pumblend = 10,
  pumheight = 10,
  shiftround = true,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,

  expandtab = true,
  ignorecase = true,

  scrolloff = 0,
  sidescrolloff = 0,

  shiftwidth = 2,
  tabstop = 2,
  wrap = false,

  spell = false,
  spelllang = 'en_us',
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

vim.opt.shortmess:append({ W = true, I = true, c = true })

vim.opt.fillchars:append({
  vert = "|",
  vertright = "|",
  vertleft = "|",
  verthoriz = "+",
  horiz = "-",
  horizup = "-",
  horizdown = "-",
  diff = "╱"
})

vim.cmd.colorscheme("gruvbox-material")
