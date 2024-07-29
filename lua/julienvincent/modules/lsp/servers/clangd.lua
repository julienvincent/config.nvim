local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return {
  name = "clangd",
  filetypes = { "cpp"  },

  cmd = mason.command("clangd"),
  root_dir = fs.find_furthest_root({
    "CMakeLists.txt",
  }, fs.fallback_fn_cwd),

  single_file_support = true,
  init_options = {
  },

  handlers = {
    ["textDocument/rename"] = function(...)
      local saving = require("julienvincent.modules.core.auto-save")

      vim.lsp.handlers["textDocument/rename"](...)
      saving.write_all_buffers()
    end,
  },
}
