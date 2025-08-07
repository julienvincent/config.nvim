return function()
  local mason = require("julienvincent.modules.core.mason")

  local paths = mason.get_package("cljfmt")
  if not paths then
    return
  end

  return {
    command = paths.bin,
    cwd = function(_, ctx)
      local buf_path = vim.api.nvim_buf_get_name(ctx.buf)
      if #buf_path > 0 then
        return vim.fs.root(buf_path, { ".cljfmt.edn" })
      end
    end,
  }
end
