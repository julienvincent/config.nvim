local nrepl = require("julienvincent.modules.clojure.nrepl.api")

local M = {}

local LAST_RUN_BINDINGS = {}

local function set_add(tbl, item)
  local filtered = vim.tbl_filter(function(value)
    return value ~= item
  end, tbl)
  table.insert(filtered, 1, item)
  return filtered
end

local function sort_by_partial_table(main_table, order_table)
  local order_lookup = {}
  for i, v in ipairs(order_table) do
    order_lookup[v] = i
  end

  table.sort(main_table, function(a, b)
    local order_a, order_b = order_lookup[a], order_lookup[b]

    if order_a and order_b then
      return order_a < order_b
    elseif order_a then
      return true
    elseif order_b then
      return false
    else
      return tostring(a) < tostring(b)
    end
  end)

  return main_table
end

function M.list_bindings(binding_name, cb)
  nrepl.eval("jv.repl", "(list-bindings " .. binding_name .. ")", {
    ["passive?"] = true,
    ["on-result"] = function(result)
      local syms = {}
      for line in result:sub(2, -2):gmatch("[^%s]+") do
        table.insert(syms, line)
      end
      cb(syms)
    end,
  })
end

function M.pick_binding(bindings, cb)
  if #bindings == 1 then
    return cb(bindings[1])
  end

  sort_by_partial_table(bindings, LAST_RUN_BINDINGS)

  vim.ui.select(bindings, "Pick binding to run", function(item)
    if not item then
      return
    end
    LAST_RUN_BINDINGS = set_add(LAST_RUN_BINDINGS, item)
    return cb(item)
  end)
end

function M.run_binding(binding_name, before_run_cb)
  M.list_bindings(binding_name, function(bindings)
    M.pick_binding(bindings, function(binding)
      nrepl.log_append({ ";; Running " .. binding })

      if before_run_cb then
        before_run_cb()
      end

      nrepl.eval("jv.repl", "(run-binding! " .. binding_name .. " '" .. binding .. ")")
    end)
  end)
end

return M
