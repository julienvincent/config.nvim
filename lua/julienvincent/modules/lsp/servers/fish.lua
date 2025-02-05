return {
  name = "fish-lsp",
  filetypes = { "fish" },

  cmd = function()
    if vim.fn.executable("fish-lsp") ~= 1 then
      return
    end
    return { "fish-lsp", "start" }
  end,
  cmd_env = { fish_lsp_show_client_popups = false },

  single_file_support = true,
}
