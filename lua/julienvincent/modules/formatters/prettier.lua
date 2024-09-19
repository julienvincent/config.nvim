return function()
  local mason = require("julienvincent.modules.core.mason")

  local paths = mason.get_package("prettier")
  if not paths then
    return
  end

  return {
    command = paths.bin,
    append_args = function(_, opts)
      local args = { "--prose-wrap=always" }
      local textwidth = vim.api.nvim_get_option_value("textwidth", {
        buf = opts.buf,
      })
      if textwidth then
        table.insert(args, "--print-width=" .. textwidth)
      end
      return args
    end,
  }
end
