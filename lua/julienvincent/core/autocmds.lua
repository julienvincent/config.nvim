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

-- autocmd("VimEnter", {
--   group = general,
--   desc = "Set the cwd to the opened directory",
--   callback = function(data)
--     local directory = vim.fn.isdirectory(data.file) == 1
--     if directory then
--       vim.cmd.cd(data.file)
--     end
--     print(vim.fn.getcwd())
--   end,
-- })

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
