local function mod(name)
  return require("julienvincent.modules.lsp.servers." .. name)
end

return {
  mod("clojure"),
  mod("lua_ls"),
  mod("yamlls"),
  mod("jsonls"),
  mod("spicedb"),
  mod("tsserver"),
  mod("jdtls"),
  mod("rust_analyzer"),
  -- mod("ltex"),
  mod("harper"),
  mod("clangd"),
  mod("nim"),
  mod("fish"),
  mod("taplo"),
  mod("tailwind"),
}
