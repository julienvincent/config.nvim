local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })

autocmd("FocusLost", {
  pattern = "*",
  group = general,
  desc = "Auto save all buffers when focus is lost",
  callback = function()
    vim.api.nvim_command("wa")
  end,
})

autocmd("FileType", {
  pattern = { "clojure" },
  group = general,
  desc = "Override the definition of a word for clojure files",
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")
  end,
})

autocmd("BufNewFile", {
  pattern = "conjure-log-*",
  group = general,
  desc = "Disable diagnostics in conjure log buffer",
  callback = function(event)
    vim.diagnostic.disable(event.buf)
  end,
})

-- local colors = require("gruvbox.palette").colors;
--
-- function FixGruvbox()
--   vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = "#431313" })
--   vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "none", fg = colors.dark2 })
--   vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { bg = "none", fg = colors.dark2 })
--   vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#142a03" })
--   vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#3B3307" })
--   vim.api.nvim_set_hl(0, 'DiffText', { bg = "#4D520D" })
-- end
-- FixGruvbox()
--
-- vim.api.nvim_create_autocmd(
--   "ColorScheme",
--     { pattern = { "gruvbox" }, callback = FixGruvbox }
-- )
