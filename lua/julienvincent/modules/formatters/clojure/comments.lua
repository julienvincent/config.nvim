local function reverse_iter(elements)
  local results = {}
  for _, child in elements do
    table.insert(results, 1, child)
  end
  return results
end

local function reposition_comment(buf, comment)
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
  if delta == 0 then
    return
  end

  if delta > 0 then
    local chars = string.rep(" ", delta)
    vim.api.nvim_buf_set_text(buf, range[1], 0, range[1], 0, { chars })
  else
    vim.api.nvim_buf_set_text(buf, range[1], 0, range[1], delta * -1, {})
  end
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

local function fix_comment_line_breaks(buf, comments)
  local range_start = { comments[#comments]:range() }
  local range_end = { comments[1]:range() }
  local start_row = range_start[1] + 1
  local end_row = range_end[3]

  vim.api.nvim_buf_call(buf, function()
    vim.cmd(string.format("normal! %dGv%dGgq", start_row, end_row))
  end)
end

local function reposition_comments(buf, comments)
  for _, comment in ipairs(comments) do
    reposition_comment(buf, comment)
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

local SCRATCH_BUF = nil

local function init_scratch_buf()
  if SCRATCH_BUF then
    return SCRATCH_BUF
  end

  SCRATCH_BUF = vim.api.nvim_create_buf(false, true)

  local opts = {
    textwidth = vim.api.nvim_get_option_value("textwidth", {
      buf = 0,
    }) or 80,
    formatoptions = vim.api.nvim_get_option_value("formatoptions", {
      buf = 0,
    }),
    shiftwidth = 2,
    filetype = "clojure",
  }

  for option, value in pairs(opts) do
    vim.api.nvim_set_option_value(option, value, {
      buf = SCRATCH_BUF,
    })
  end

  return SCRATCH_BUF
end

local function prepare_scratch_buffer(lines)
  local buf = init_scratch_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local tree = vim.treesitter.get_parser(buf):parse()[1]
  return buf, tree
end

return function()
  return {
    format = function(_, ctx, lines, callback)
      local buf, tree = prepare_scratch_buffer(lines)
      if not tree then
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
        return
      end

      local comments
      if range then
        comments = query:iter_captures(root, buf, range[1] - 1, range[3])
      else
        comments = query:iter_captures(root, buf)
      end

      comments = reverse_iter(comments)
      reposition_comments(buf, comments)

      local groups = group_related_comments(filter_double_comments(buf, comments))
      for _, grouped_comments in ipairs(groups) do
        fix_comment_line_breaks(buf, grouped_comments)
      end

      local formatted_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      callback(nil, formatted_lines)
    end,
  }
end
