local BUFFER_DATA = {}

local function get_buf_opt(buf, opt)
  local map = BUFFER_DATA[buf] or {}
  return map[opt]
end

local function init_buf(ref_buf, opts)
  local buf = vim.api.nvim_create_buf(false, true)

  local offset = opts.offset or 0
  local textwidth = get_buf_opt(ref_buf, "textwidth")
    or vim.api.nvim_get_option_value("textwidth", {
      buf = ref_buf,
    })
    or 80

  local buf_opts = {
    formatoptions = vim.api.nvim_get_option_value("formatoptions", {
      buf = ref_buf,
    }),
    filetype = opts.ft or vim.api.nvim_get_option_value("filetype", {
      buf = ref_buf,
    }),
    textwidth = textwidth - offset,
    shiftwidth = 2,
    swapfile = false,
  }

  for option, value in pairs(buf_opts) do
    vim.api.nvim_set_option_value(option, value, {
      buf = buf,
    })
  end

  BUFFER_DATA[buf] = {
    textwidth = buf_opts.textwidth,
  }

  local buf_name = vim.api.nvim_buf_get_name(ref_buf)
  buf_name = buf_name .. "." .. buf .. "." .. buf_opts.filetype
  vim.api.nvim_buf_set_name(buf, buf_name)

  return buf
end

local function destroy_tmp_buffer(buf)
  BUFFER_DATA[buf] = nil
  vim.api.nvim_buf_delete(buf, { force = true })
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

return function()
  return {
    format = function(_, ctx, lines, callback)
      local nio = require("nio")
      local conform = require("conform")

      local buf = init_buf(ctx.buf, {})
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

      local parser = vim.treesitter.get_parser(buf)
      if not parser then
        return callback("No TS parser")
      end

      local range
      if ctx.range then
        -- stylua: ignore
        range = {
          ctx.range["start"][1], ctx.range["start"][2],
          ctx.range["end"][1], ctx.range["end"][2],
        }
      end
      if range then
        parser:parse(range)
      else
        parser:parse(true)
      end

      local format = nio.wrap(function(opts, cb)
        conform.format(opts, function(err, did_edit)
          cb(not err and did_edit)
        end)
      end, 2)

      local injections = {}
      for lang, child_tree in pairs(parser:children()) do
        if conform.formatters_by_ft[lang] then
          for _, region in ipairs(child_tree:included_regions()) do
            -- stylua: ignore
            local injection_range = {
              region[1][1], region[1][2],
              region[1][4], region[1][5],
            }

            local included_in_range = range and injection_range[1] >= range[1] and injection_range[4] <= range[4]
            if not range or included_in_range then
              local root = child_tree:named_node_for_range(injection_range)
              if root then
                table.insert(injections, {
                  -- This is more correct but it results in bad formatting by default in markdown
                  range = { root:range() },
                  -- range = injection_range,
                  node = root,
                  lang = lang,
                })
              end
            end
          end
        end
      end

      local tasks = vim.tbl_map(function(injection)
        return function()
          local offset = injection.range[2] + 1
          local raw_text = vim.split(vim.treesitter.get_node_text(injection.node, buf), "\n")

          local tmp_buf = init_buf(ctx.buf, {
            ft = injection.lang,
            offset = offset,
          })
          vim.api.nvim_buf_set_lines(tmp_buf, 0, -1, false, raw_text)

          local format_range = nil
          if range then
            format_range = {
              start = { 1, 0 },
              ["end"] = { #raw_text + 1, #raw_text[#raw_text] - 1 },
            }
          end

          local did_edit = format({
            async = true,
            bufnr = tmp_buf,
            range = format_range,
          })

          if not did_edit then
            return nil
          end

          local formatted_lines = vim.api.nvim_buf_get_lines(tmp_buf, 0, -1, false)
          destroy_tmp_buffer(tmp_buf)
          local re_indented = add_offset_indentation(trim_end(formatted_lines), offset - 1)

          -- If it ends on a new line, we should add that new line back into the formatted text
          if injection.range[4] == 0 then
            table.insert(re_indented, string.rep(" ", offset - 1))
          end

          return {
            lines = re_indented,
            node = injection.node,
            range = injection.range,
          }
        end
      end, injections)

      if #tasks == 0 then
        callback(nil, lines)
      end

      nio.run(function()
        local results = vim.tbl_filter(function(result)
          return result
        end, nio.gather(tasks))

        if #results == 0 then
          return callback(nil, lines)
        end

        table.sort(results, function(a, b)
          return a.range[1] > b.range[1]
        end)

        for _, result in ipairs(results) do
          -- stylua: ignore
          vim.api.nvim_buf_set_text(buf,
            result.range[1], result.range[2],
            result.range[3], result.range[4],
            result.lines
          )
        end

        local formatted_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        destroy_tmp_buffer(buf)
        callback(nil, formatted_lines)
      end, function(success, e)
        if not success then
          print(e)
          callback(e)
        end
      end)
    end,
  }
end
