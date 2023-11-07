local M = {}

function M.set_gruvbox_material_dark()
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
  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#46413e",
  })

  -- Search
  vim.api.nvim_set_hl(0, "Search", {
    bg = "#7c6f64",
  })
  vim.api.nvim_set_hl(0, "IncSearch", {
    bg = "#d79921",
    fg = "#32302f",
  })
end

function M.set_gruvbox_material_light() end

function M.set_gruvbox_material_overrides()
  if vim.o.background == "dark" then
    M.set_gruvbox_material_dark()
  elseif vim.o.background == "light" then
    M.set_gruvbox_material_light()
  end
end

function M.set_highlight_overrides()
  if vim.g.colors_name == "gruvbox-material" then
    vim.cmd.colorscheme("gruvbox-material")
    M.set_gruvbox_material_overrides()
  end
end

M.setup = function()
  vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    callback = function()
      M.set_highlight_overrides()
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = { "*" },
    callback = function()
      M.set_highlight_overrides()
    end,
  })

  vim.o.background = "dark"
  vim.cmd.colorscheme("gruvbox-material")
end

return M
