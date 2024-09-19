local M = {}

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

local function is_html_tag(line)
    return string.match(line, "^%s*<%/?%s*[%w:-]+%s*>") ~= nil
end

local function is_block(str)
  local trimmed = vim.fn.trim(str)
  local is_code_block = string.sub(trimmed, 1, 3) == "```"
  return is_code_block or is_html_tag(trimmed)
end

local function paragraphs_to_words(paragraphs)
  local currently_in_block = false
  return vim.tbl_map(function(paragraph)
    local lines = {}

    local words = {}
    for _, line in ipairs(paragraph) do
      if is_block(line) or currently_in_block then
        local block_start = is_block(line) and not currently_in_block
        local block_end = is_block(line) and currently_in_block

        if block_start then
          if #words > 0 then
            table.insert(lines, words)
            words = {}
          end
          currently_in_block = true
        end

        if currently_in_block then
          local word = line
          if block_start or block_end then
            word = vim.fn.trim(word)
          end
          table.insert(lines, {
            word,
            block_start = block_start,
            block_end = block_end,
          })
        end

        if block_end then
          currently_in_block = false
        end
      else
        if is_list(line) then
          if #words > 0 then
            table.insert(lines, words)
            words = {}
          end
        end

        for _, word in ipairs(vim.fn.split(line, " ")) do
          if word ~= "" then
            table.insert(words, word)
          end
        end
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
    local current_line = {
      block_start = line.block_start,
      block_end = line.block_end,
    }
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

function M.format_string(input_lines, opts)
  local offset = opts.offset or 0

  local paragraphs = lines_to_paragrapphs(input_lines)
  local as_words = paragraphs_to_words(paragraphs)

  local rewritten = rewrite_paragraphs(as_words, opts)

  local lines = {}
  local in_block = false
  for _, paragraph in ipairs(rewritten) do
    if #lines > 0 then
      table.insert(lines, "")
    end

    for _, line in ipairs(paragraph) do
      local offset_padding = ""
      if line.block_end then
        in_block = false
      end
      if not in_block then
        offset_padding = string.rep(" ", offset)
      end
      if line.block_start then
        in_block = true
      end
      table.insert(lines, offset_padding .. table.concat(line, " "))
    end
  end

  return lines
end

return M
