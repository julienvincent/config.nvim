local M = {}

local THEME_MAPPING = {
  dark = "gruvbox-material",
  light = "default",
}

function M.get_macos_system_theme()
  local cmd = [[defaults read -g AppleInterfaceStyle]]
  local res = vim.fn.system(cmd)
  if res:match("Dark") then
    return "dark"
  end
  return "light"
end

local os_info = vim.loop.os_uname()
function M.get_system_theme()
  if os_info.sysname == "Darwin" then
    return M.get_macos_system_theme()
  end
end

local function override_gruvbox_material_dark()
  local palette = vim.fn["gruvbox_material#get_palette"]("soft", "mix", vim.empty_dict())

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

  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#46413e",
  })

  vim.api.nvim_set_hl(0, "MatchParen", {
    bg = palette.bg5[1],
  })

  -- Search
  vim.api.nvim_set_hl(0, "Search", {
    bg = palette.grey0[1],
  })
  vim.api.nvim_set_hl(0, "IncSearch", {
    bg = "#d79921",
    fg = "#32302f",
  })

  vim.api.nvim_set_hl(0, "NormalFloat", {
    bg = palette.bg1[1],
  })
  vim.api.nvim_set_hl(0, "FloatBorder", {
    bg = palette.bg1[1],
    fg = palette.grey2[1],
  })
  vim.api.nvim_set_hl(0, "FloatTitle", {
    bg = palette.bg1[1],
    fg = palette.grey2[1],
  })

  -- Snacks Picker
  vim.api.nvim_set_hl(0, "SnacksInputBorder", {
    link = "Yellow",
  })

  vim.api.nvim_set_hl(0, "SnacksInputTitle", {
    link = "Orange",
  })
end

local function override_gruvbox_material_light()
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })
end

local function override_default_dark() end

local function override_default_light()
  vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#997633" })
end

function M.set_gruvbox_material_overrides()
  if vim.o.background == "dark" then
    M.override_gruvbox_material_dark()
  elseif vim.o.background == "light" then
    M.override_gruvbox_material_light()
  end
end

local OVERRIDE_MAPPING = {
  ["gruvbox-material-dark"] = override_gruvbox_material_dark,
  ["gruvbox-material-light"] = override_gruvbox_material_light,

  ["default-dark"] = override_default_dark,
  ["default-light"] = override_default_light,
}

function M.set_highlight_overrides()
  local key = vim.g.colors_name .. "-" .. vim.o.background
  local override = OVERRIDE_MAPPING[key]
  if override then
    override()
  end

  vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", {
    link = "CursorLine",
  })
end

function M.update_theme_from_system()
  local theme = M.get_system_theme()
  if not theme then
    return
  end

  if vim.o.background ~= theme then
    vim.o.background = theme
    vim.cmd.colorscheme(THEME_MAPPING[theme])
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

  vim.o.background = M.get_system_theme() or "dark"
  vim.cmd.colorscheme(THEME_MAPPING[vim.o.background])

  local timer = vim.loop.new_timer()
  timer:start(0, 10000, vim.schedule_wrap(M.update_theme_from_system))
  M.update_theme_from_system()
end

return M
