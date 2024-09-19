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
  return ts.get_node_at_cursor()
end

local root_forms = {"defn", "defmacro", "defprotocol"}

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
  if not table_contains(root_forms, type)  then
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

local function is_list(str)
  -- Pattern for unordered list items: '-', '+', or '*'
  local unordered_list_pattern = "^%s*[-+*]%s+"

  -- Pattern for ordered list items: '1)', '2.', etc.
  local ordered_list_pattern = "^%s*%d+[).]%s+"

  if string.match(str, unordered_list_pattern) then
    return true
  end

  if string.match(str, ordered_list_pattern) then
    return true
  end

  return false
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

local function paragraphs_to_words(paragraphs)
  return vim.tbl_map(function(paragraph)
    local lines = {}

    local words = {}
    for _, line in ipairs(paragraph) do
      if is_list(line) then
        if #words > 0 then
          table.insert(lines, words)
          words = {}
        end
      end

      for _, word in ipairs(vim.fn.split(line, " ")) do
        table.insert(words, word)
      end
    end

    if #words > 0 then
      table.insert(lines, words)
    end

    return lines
  end, paragraphs)
end

local function rewrite_paragraph(paragraph, opts)
  local text_width = opts.text_width or 80
  local offset = opts.offset or 0

  local new_paragraph = {}

  for _, line in ipairs(paragraph) do
    local current_line = {}
    local current_line_count = 0

    for _, word in ipairs(line) do
      if ((current_line_count + #word + offset) > text_width) and #current_line > 0 then
        table.insert(new_paragraph, current_line)
        current_line = {}
        current_line_count = 0
      end

      current_line_count = current_line_count + #word + 1
      table.insert(current_line, word)
    end

    if #current_line > 0 then
      table.insert(new_paragraph, current_line)
    end
  end

  return new_paragraph
end

local function rewrite_paragraphs(paragraphs, opts)
  return vim.tbl_map(function(paragraph)
    return rewrite_paragraph(paragraph, opts)
  end, paragraphs)
end

local function format_string(input, opts)
  local offset = opts.offset or 0

  local paragraphs = lines_to_paragrapphs(vim.fn.split(input, "\n"))
  local as_words = paragraphs_to_words(paragraphs)

  local rewritten = rewrite_paragraphs(as_words, opts)

  local lines = {}
  for _, paragraph in ipairs(rewritten) do
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
    print("no root form")
    return
  end

  local docstring = find_docstring(root_form)
  if not docstring then
    print("no docstring")
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
