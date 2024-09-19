local formatter = require("julienvincent.modules.formatters.markdown.api")

local M = {}

local function table_contains(table, elem)
  for _, item in ipairs(table) do
    if item == elem then
      return true
    end
  end
  return false
end

local function get_node_at_cursor()
  local ts = require("nvim-treesitter.ts_utils")
  -- Use current buffer and ignore injected languages.
  --
  -- Injected languages are ignored because the docstring might be injected as
  -- markdown in which case we would be traversing the wrong parser tree.
  return ts.get_node_at_cursor(0, true)
end

local root_forms = { "defn", "defn-", "defmacro", "defprotocol" }

function M.get_root_form()
  local node = get_node_at_cursor()
  if not node then
    return
  end

  local tree = node:tree()
  local root = tree:root()

  local root_form = node
  while true do
    local parent = root_form:parent()
    if not parent then
      break
    end

    if parent:id() == root:id() then
      break
    end

    root_form = parent
  end

  local form_type = root_form:named_child(0)
  local type = vim.treesitter.get_node_text(form_type, 0)
  if not table_contains(root_forms, type) then
    return
  end

  return root_form
end

local function find_docstring(node, index)
  index = index or 0
  if index < 0 or index >= node:named_child_count() then
    return
  end
  local child = node:named_child(index)
  if not child then
    return
  end
  if child:type() == "str_lit" then
    return child
  end
  if child:type() == "vec_lit" then
    return
  end
  return find_docstring(node, index + 1)
end

function M.format_docstring()
  local root_form = M.get_root_form()
  if not root_form then
    return
  end

  local docstring = find_docstring(root_form)
  if not docstring then
    return
  end

  local textwidth = vim.api.nvim_get_option_value("textwidth", {
    buf = 0,
  })

  local docstring_text = vim.treesitter.get_node_text(docstring, 0)
  local lines = vim.fn.split(docstring_text, "\n")

  local range = { docstring:range() }

  local formatted = formatter.format_string(lines, {
    text_width = textwidth or 80,
    offset = range[2],
  })

  vim.api.nvim_buf_set_text(0, range[1], 0, range[3], range[4], formatted)
end

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "clojure",
    callback = function(event)
      vim.keymap.set("n", "gq", M.format_docstring, {
        desc = "Format fn docstring",
        buffer = event.buf,
      })
    end,
  })
end

return M
