local api = require("julienvincent.modules.formatters.markdown.api")

return function ()
  return {
    format = function(_, ctx, lines, callback)
      local textwidth = vim.api.nvim_get_option_value("textwidth", {
        buf = ctx.buf,
      })

      local formatted_lines = api.format_string(lines, {
        text_width = textwidth or 80,
        offset = 0,
      })

      callback(nil, formatted_lines)
    end,
  }
end
