local icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

return {
  setup = function()
    for name, icon in pairs(icons) do
      name = "DiagnosticSign" .. name
      vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}
