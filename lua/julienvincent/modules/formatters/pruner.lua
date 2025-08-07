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
        if textwidth then
          table.insert(args, "--print-width=" .. textwidth)
        end

        local filetype = vim.api.nvim_get_option_value("filetype", {
          buf = opts.buf,
        })
        if filetype then
          table.insert(args, "--lang=" .. filetype)
        end

        if config.injected_only then
          table.insert(args, "--skip-root")
        end

        return args
      end,
    }
  end
end
