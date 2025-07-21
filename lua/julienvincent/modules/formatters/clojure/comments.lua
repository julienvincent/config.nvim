local function reverse_iter(elements)
  local results = {}
  for _, child in elements do
    table.insert(results, 1, child)
  end
  return results
end

local function calculate_offset(comment)
  local range = { comment:range() }

  local next_sibling = comment:next_named_sibling()
  local prev_sibling = comment:prev_named_sibling()

  if prev_sibling then
    local sibling_range = { prev_sibling:range() }
    if sibling_range[1] == range[1] then
      return
    end
  end

  local sibling_range = { next_sibling:range() }

  local delta = sibling_range[2] - range[2]
  return range[2] + delta
end

local function is_double_comment(buf, comment)
  local node_range = { comment:range() }
  -- stylua: ignore
  local comment_type = vim.api.nvim_buf_get_text(buf,
    node_range[1], node_range[2],
    node_range[1], node_range[2] + 2,
    {}
  )[1]
  return comment_type == ";;"
end

local function filter_double_comments(buf, comments)
  return vim.tbl_filter(function(comment)
    return is_double_comment(buf, comment)
  end, comments)
end

local function format_markdown(buf, lines, offset)
  local mason = require("julienvincent.modules.core.mason")
  local paths = mason.get_package("prettierd")
  if not paths then
    return
  end

  local textwidth = vim.api.nvim_get_option_value("textwidth", {
    buf = buf,
  }) or 80

  local args = {
    paths.bin,
    "--prose-wrap=always",
    "--print-width=" .. (textwidth - offset),
    "--stdin-filepath",
    "docstrings.md",
  }

  local stdout = {}
  local handle = vim.fn.jobstart(args, {
    stdin = "pipe",
    stdout_buffered = false,
    on_stdout = function(_, data)
      if data then
        vim.list_extend(stdout, data)
      end
    end,
  })

  for _, line in ipairs(lines) do
    vim.fn.chansend(handle, line)
    vim.fn.chansend(handle, "\n")
  end
  vim.fn.chanclose(handle, "stdin")

  local status = vim.fn.jobwait({ handle }, -1)[1]
  if status == 0 then
    return stdout
  end

  vim.notify(stdout[1], vim.log.levels.WARN)
end

local function trim_end(lines)
  while lines[#lines] == "" do
    table.remove(lines)
  end
  return lines
end

local function add_offset_indentation(lines, offset)
  local i = 0
  return vim.tbl_map(function(line)
    i = i + 1
    if i == 1 then
      return line
    end

    if line == "" then
      return line
    end

    local chars = string.rep(" ", offset)
    return chars .. line
  end, lines)
end

local function format_comments(buf, comments)
  local lines = {}
  for i, _ in ipairs(comments) do
    local comment = comments[#comments - i + 1]
    local comment_lines = vim.split(vim.treesitter.get_node_text(comment, buf), "\n")
    for _, line in ipairs(comment_lines) do
      local replaced = line:gsub(";;", "")
      table.insert(lines, replaced)
    end
  end

  local range_start = { comments[#comments]:range() }
  local range_end = { comments[1]:range() }
  local offset = calculate_offset(comments[1])

  -- The +3 accounts for the three characters that make up ';; '
  local formatted_lines = format_markdown(buf, lines, offset + 3)
  if not formatted_lines then
    return
  end

  local commented_lines = {}
  for _, line in ipairs(trim_end(formatted_lines)) do
    table.insert(commented_lines, ";; " .. line)
  end
  table.insert(commented_lines, "")

  local re_indented = add_offset_indentation(commented_lines, offset)

  -- stylua: ignore
  vim.api.nvim_buf_set_text(buf,
    range_start[1], range_start[2],
    range_end[3], range_end[4],
    re_indented
  )

  local delta = offset - range_start[2]
  if delta > 0 then
    local chars = string.rep(" ", delta)
    vim.api.nvim_buf_set_text(buf, range_start[1], 0, range_start[1], 0, { chars })
  else
    vim.api.nvim_buf_set_text(buf, range_start[1], 0, range_start[1], delta * -1, {})
  end
end

local function group_related_comments(comments)
  local groups = {}
  local prev = nil
  local current_group = {}
  for _, comment in ipairs(comments) do
    if not prev then
      current_group = { comment }
      prev = comment
    else
      local next_sibling = comment:next_named_sibling()
      local prev_sibling = comment:prev_named_sibling()
      local prev_same_group = prev_sibling and prev_sibling:equal(prev)
      local next_same_group = next_sibling and next_sibling:equal(prev)
      if prev_same_group or next_same_group then
        table.insert(current_group, comment)
      else
        table.insert(groups, current_group)
        current_group = { comment }
      end
      prev = comment
    end
  end
  if #current_group > 0 then
    table.insert(groups, current_group)
  end
  return groups
end

local function init_scratch_buf(ref_buf)
  local buf = vim.api.nvim_create_buf(false, true)

  local opts = {
    textwidth = vim.api.nvim_get_option_value("textwidth", {
      buf = ref_buf,
    }) or 80,
    formatoptions = vim.api.nvim_get_option_value("formatoptions", {
      buf = ref_buf,
    }),
    shiftwidth = 2,
    filetype = "clojure",
  }

  for option, value in pairs(opts) do
    vim.api.nvim_set_option_value(option, value, {
      buf = buf,
    })
  end

  return buf
end

return function()
  return {
    format = function(_, ctx, lines, callback)
      local buf = init_scratch_buf(ctx.buf)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      local tree = vim.treesitter.get_parser(buf):parse(true)[1]
      if not tree then
        vim.api.nvim_buf_delete(buf, { force = true })
        callback(nil, lines)
        return
      end

      local range
      if ctx.range then
        -- stylua: ignore
        range = {
          ctx.range["start"][1], ctx.range["start"][2],
          ctx.range["end"][1], ctx.range["end"][2],
        }
      end

      local root = tree:root()

      local query = vim.treesitter.query.get("clojure", "formatting/comments")
      if not query then
        vim.api.nvim_buf_delete(buf, { force = true })
        callback(nil, lines)
        return
      end

      local comments
      if range then
        comments = query:iter_captures(root, buf, range[1] - 1, range[3])
      else
        comments = query:iter_captures(root, buf)
      end

      comments = reverse_iter(comments)

      local groups = group_related_comments(filter_double_comments(buf, comments))
      for _, grouped_comments in ipairs(groups) do
        format_comments(buf, grouped_comments)
      end

      local formatted_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      vim.api.nvim_buf_delete(buf, { force = true })
      callback(nil, formatted_lines)
    end,
  }
end
