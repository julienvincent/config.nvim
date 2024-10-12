local M = {}

local function map(lhs, rhs, bufnr, desc)
  vim.keymap.set("n", lhs, rhs, {
    silent = true,
    buffer = bufnr,
    desc = desc,
  })
end

function M.setup_on_attach_keybinds(buf)
  map("<leader>lr", vim.lsp.buf.rename, buf, "Rename symbol")
  map("<leader>la", vim.lsp.buf.code_action, buf, "Code actions")
  map("K", vim.lsp.buf.hover, buf, "Hover doc")
  map("<localleader>d", vim.diagnostic.open_float, buf, "Show diagnostics at cursor")

  map("gd", function()
    require("fzf-lua").lsp_definitions({
      jump_to_single_result = true,
    })
  end, buf, "Go to definition")
  map("gD", ":vsp<CR><cmd>lua vim.lsp.buf.definition()<CR>", buf, "Go to definition vertical split")
  map("<leader>gD", function()
    require("fzf-lua").diagnostics_workspace()
  end, buf, "Show project diagnostics")

  map("gi", function()
    require("fzf-lua").lsp_implementations()
  end, buf, "Go to implementations")
  map("gr", function()
    require("fzf-lua").lsp_references({
      ignore_current_line = true,
      includeDeclaration = true,
    })
  end, buf, "Go to references")

  map("gs", function()
    require("fzf-lua").lsp_workspace_symbols()
  end, buf, "Symbol references")

  map("gS", function()
    require("fzf-lua").lsp_document_symbols()
  end, buf, "Symbol references")

  map("<leader>lti", vim.lsp.buf.incoming_calls)
  map("<leader>lto", vim.lsp.buf.outgoing_calls)
end

return M
