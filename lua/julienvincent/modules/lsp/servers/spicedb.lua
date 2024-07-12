return {
  name = "spicedb",
  filetypes = { "authzed" },

  cmd = function()
    if vim.fn.executable("spicedb") ~= 1 then
      return
    end

    return { "spicedb", "lsp", "--stdio" }
  end,
  root_dir = nil,

  single_file_support = true,
}
