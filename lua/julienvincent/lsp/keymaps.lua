return {
  g = {
    d = { ":Telescope lsp_definitions<cr>", "Go to Definition" },
    i = { ":Telescope lsp_implementations<cr>", "Go to Impementations" },
    r = { ":Telescope lsp_references<cr>", "Symbol References" },
    t = { ":Telescope lsp_type_definitions<cr>", "Type Definitions" },
  },
  t = { ":Telescope lsp_type_definitions<cr>", "Type Definition" },
  ["<leader>"] = {
    l = {
      f = { vim.lsp.buf.format, "Format" },
      r = { vim.lsp.buf.rename, "Rename" },
      R = { ":LspRestart<cr>", "Lsp Restart" },
      a = { vim.lsp.buf.code_action, "Code Action" },
      I = { ":LspInfo<cr>", "Lsp Info" },
    },
  },
  K = { vim.lsp.buf.hover, "Hover doc" },
}
