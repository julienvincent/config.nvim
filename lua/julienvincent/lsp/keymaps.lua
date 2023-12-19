local M = {}

local function map(lhs, rhs, bufnr, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

local function Telescope(cmd)
  return function()
    vim.cmd.Telescope(cmd)
  end
end

M.which_key_keys = {
  ["<leader>"] = {
    l = { "LSP" },
  },
}

function M.setup_global_keybinds()
  vim.keymap.set("n", "<leader>lR", "<Cmd>LspRestart<Cr>", { silent = true, desc = "Restart LSP" })
  vim.keymap.set("n", "<leader>lI", "<Cmd>LspInfo<Cr>", { silent = true, desc = "Get LSP info" })
end

function M.setup_on_attach_keybinds(buf)
  map("<leader>lr", vim.lsp.buf.rename, buf, "Rename symbol")
  map("<leader>la", vim.lsp.buf.code_action, buf, "Code actions")
  map("K", vim.lsp.buf.hover, buf, "Hover doc")
  map("<localleader>d", vim.diagnostic.open_float, buf, "Show diagnostics at cursor")

  map("gd", Telescope("lsp_definitions"), buf, "Go to definition")
  map("gi", Telescope("lsp_implementations"), buf, "Go to implementations")
  map("gr", Telescope("lsp_references"), buf, "Symbol references")
  map("gt", Telescope("lsp_type_definitions"), buf, "Type definitions")
end

return M
