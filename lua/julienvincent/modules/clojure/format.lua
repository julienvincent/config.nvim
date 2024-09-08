local M = {}

local function get_node_at_cursor()
  local ts = require("nvim-treesitter.ts_utils")
  return ts.get_node_at_cursor()
end

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
  if vim.treesitter.get_node_text(form_type, 0) ~= "defn" then
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

local function is_whitespace(str)
  return str:match("^%s*$") ~= nil
end

local function lines_to_paragrapphs(lines)
  local paragraphs = {}

  for _, line in ipairs(lines) do
    local current_paragraph = paragraphs[#paragraphs]
    if not current_paragraph then
      current_paragraph = {}
      table.insert(paragraphs, current_paragraph)
    end

    if is_whitespace(line) then
      if #current_paragraph > 0 then
        table.insert(paragraphs, {})
      end
    else
      table.insert(current_paragraph, line)
    end
  end

  return paragraphs
end

local function format_string(input, opts)
  local text_width = opts.text_width or 80
  local offset = opts.offset or 0

  local paragraphs = lines_to_paragrapphs(vim.fn.split(input, "\n"))

  local formatted_paragraphs = vim.tbl_map(function(paragraph)
    local words = {}

    for _, line in ipairs(paragraph) do
      for _, word in ipairs(vim.fn.split(line, " ")) do
        table.insert(words, word)
      end
    end

    local lines = {}

    local line = {}
    local line_count = 0
    for _, word in ipairs(words) do
      if line_count + #word + offset > text_width and #line > 0 then
        table.insert(lines, line)
        line = {}
        line_count = 0
      end

      line_count = line_count + #word + 1
      table.insert(line, word)
    end

    if #line > 0 then
      table.insert(lines, line)
    end

    return lines
  end, paragraphs)

  local lines = {}
  for _, paragraph in ipairs(formatted_paragraphs) do
    if #lines > 0 then
      table.insert(lines, "")
    end

    for _, line in ipairs(paragraph) do
      table.insert(lines, string.rep(" ", offset) .. table.concat(line, " "))
    end
  end

  return lines
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

  local docstring_text = vim.treesitter.get_node_text(docstring, 0)

  local range = { docstring:range() }

  local formatted = format_string(docstring_text, {
    text_width = 80,
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
