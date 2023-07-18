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

autocmd("BufLeave", {
  pattern = "*",
  group = general,
  desc = "Auto save buffers when I leave them",
  callback = function()
    if vim.bo.modified and vim.bo.modifiable and #vim.fn.bufname("%") > 0 then
      vim.api.nvim_command("write")
    end
  end,
})

autocmd("FileType", {
  pattern = { "*" },
  group = general,
  desc = "Override the definition of a keyword",
  callback = function()
    vim.cmd("setlocal iskeyword=@,48-57,_,192-255,!,?")
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.zed" },
  group = general,
  desc = "Set the filetype of .zed files",
  callback = function(event)
    vim.api.nvim_buf_set_option(event.buf, "filetype", "authzed")
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

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable spellcheck for certain filetypes",
  group = general,
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable line wrapping for certain filetypes",
  group = general,
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close certain filetypes with <q>",
  group = general,
  pattern = {
    "help",
    "lspinfo",
    "man",
    "spectre_panel",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd(
  "ColorScheme",
  {
    pattern = { "*" },
    callback = function()
      -- DIAGNOSTICS --
      vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { link = "Comment" })
      vim.api.nvim_set_hl(0, 'ErrorText', {
        undercurl = true,
        sp = "#f2594b"
      })
      vim.api.nvim_set_hl(0, 'HintText', {
        undercurl = true,
        sp = "#e9b143"
      })

      -- DIFF --
      vim.api.nvim_set_hl(0, 'DiffChange', {
        link = "DiffAdd"
      })
      vim.api.nvim_set_hl(0, 'DiffText', {
        bg = "#707553"
      })

      vim.api.nvim_set_hl(0, 'VertSplit', {
        bg = "#3c3836",
        fg = "#a89984"
      })

      vim.api.nvim_set_hl(0, 'CursorColumn', {
        bg = "#504945"
      })
    end
  }
)
