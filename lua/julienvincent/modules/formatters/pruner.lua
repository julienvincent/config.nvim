return function(config)
  config = config or {}

  return function()
    return {
      command = "pruner",
      args = function(_, opts)
        local args = { "format" }

        local textwidth = vim.api.nvim_get_option_value("textwidth", {
          buf = opts.buf,
        })
        if textwidth and textwidth > 0 then
          table.insert(args, "--print-width=" .. textwidth)
        end

        local filetype = vim.api.nvim_get_option_value("filetype", {
          buf = opts.buf,
        })
        table.insert(args, "--lang=" .. filetype)

        if config.profile then
          table.insert(args, "--profile=" .. config.profile)
        end

        return args
      end,
    }
  end
end
