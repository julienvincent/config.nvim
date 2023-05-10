local opts = {
  conceallevel = 0,
  cursorline = true,
  termguicolors = true,
  list = true,
  mouse = "a",
  winminwidth = 5,

  undofile = true,
  undolevels = 10000,
  -- updatetime = 200,

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
}

-- Set options from table
for opt, val in pairs(opts) do
  vim.o[opt] = val
end

vim.cmd.colorscheme("gruvbox")
