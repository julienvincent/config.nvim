local M = {}

local keywords_by_ft = {
  clojure = "@,48-57,_,192-255,!,?",
  default = "@,48-57,_,192-255",
}

M.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    desc = "Override the iskeyword for all languages",
    group = vim.api.nvim_create_augroup("LanguageKeywords", { clear = true }),
    pattern = { "*" },
    callback = function(event)
      local buf = event.buf
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })

      local keyword = keywords_by_ft[filetype]
      if not keyword then
        keyword = keywords_by_ft.default
      end

      if keyword then
        vim.opt_local.iskeyword = keyword
      end
    end,
  })
end

return M
