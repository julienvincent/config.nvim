local function format_markdown(lines, offset)
  local mason = require("julienvincent.modules.core.mason")
  local paths = mason.get_package("prettierd")
  if not paths then
    return
  end

  local textwidth = vim.api.nvim_get_option_value("textwidth", {
    buf = 0,
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

  vim.fn.chansend(handle, lines)
  vim.fn.chanclose(handle, "stdin")

  local status = vim.fn.jobwait({ handle }, -1)[1]
  if status == 0 then
    return stdout
  end

  vim.notify(stdout[1], vim.log.levels.WARN)
end

local function escape_unescaped(str)
  return str:gsub("\\", ""):gsub('"', '\\"')
end

local function add_offset_indentation(lines, offset)
  local i = 0
  return vim.tbl_map(function(line)
    i = i + 1
    if i == 1 then
      return escape_unescaped(line)
    end

    if line == "" then
      return line
    end

    local chars = string.rep(" ", offset)
    return chars .. escape_unescaped(line)
  end, lines)
end

local function trim_end(lines)
  while lines[#lines] == "" do
    table.remove(lines)
  end
  return lines
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

      local query = vim.treesitter.query.get("clojure", "formatting/docstrings")
      if not query then
        return
      end

      local captures
      if range then
        captures = query:iter_captures(root, buf, range[1] - 1, range[3])
      else
        captures = query:iter_captures(root, buf)
      end

      local docstring_matches = {}
      for id, node, metadata in captures do
        if query.captures[id] == "docstring" then
          table.insert(docstring_matches, 1, { node = node, metadata = metadata[id] })
        end
      end

      for _, match in ipairs(docstring_matches) do
        local node = match.node
        local node_range = match.metadata.range
        local offset = node_range[2]

        -- The get_node_text API supports extracting the range from
        -- `opts.metadata`. Our query directive sets this metadata, so passing
        -- it here should feed right through.
        local raw_text = vim.treesitter.get_node_text(node, buf, match)
        local formatted = format_markdown(raw_text, offset)

        if formatted then
          local re_indented = add_offset_indentation(trim_end(formatted), offset - 1)

          -- stylua: ignore
          vim.api.nvim_buf_set_text(buf,
            node_range[1], node_range[2],
            node_range[3], node_range[4],
            re_indented
          )
        end
      end

      local formatted_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      callback(nil, formatted_lines)
    end,
  }
end
