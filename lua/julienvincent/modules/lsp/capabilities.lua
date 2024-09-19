local M = {}

function M.make_client_capabilities()
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
  local file_rename_capabilities = require("lsp-file-operations").default_capabilities()

  return vim.tbl_deep_extend("force", default_capabilities, cmp_capabilities, file_rename_capabilities, {
    workspace = {
      workspaceEdit = {
        documentChanges = true,
      },
    },
  })
end

return M
