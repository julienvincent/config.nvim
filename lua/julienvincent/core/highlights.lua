local M = {}

function M.setup_highlights()
  -- DIAGNOSTICS --
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })
  vim.api.nvim_set_hl(0, "ErrorText", {
    undercurl = true,
    sp = "#f2594b",
  })
  vim.api.nvim_set_hl(0, "HintText", {
    undercurl = true,
    sp = "#e9b143",
  })

  -- DIFF --
  vim.api.nvim_set_hl(0, "DiffChange", {
    link = "DiffAdd",
  })
  vim.api.nvim_set_hl(0, "DiffText", {
    bg = "#707553",
  })

  -- BORDERS
  vim.api.nvim_set_hl(0, "VertSplit", {
    bg = "#3c3836",
    fg = "#a89984",
  })

  -- Scrollbar
  vim.api.nvim_set_hl(0, "CursorColumn", {
    bg = "#504945",
  })

  -- Search
  vim.api.nvim_set_hl(0, "Search", {
    bg = "#7c6f64",
  })
  vim.api.nvim_set_hl(0, "IncSearch", {
    bg = "#d79921",
    fg = "#32302f"
  })
end

return M
