return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      java_language_server = {},
      clojure_lsp = {
        init_options = {
          signatureHelp = true,
          codeLens = true,
        },
      },
    },
  },
}
