local function mod(name)
  return require("julienvincent.modules." .. name)
end

local modules = {
  mod("core.auto-commands"),
  mod("core.keymaps"),
  mod("core.term-title"),

  mod("core.inter-process-yank"),
  mod("core.yank-to-clipboard"),

  mod("core.auto-save"),
  mod("core.buffer-switching"),
  mod("core.highlights"),
  mod("core.diagnostics"),
  mod("core.find-and-replace"),

  mod("lang.authzed"),
  mod("lang.http"),
  mod("lang.nftables"),
  mod("lang.babashka"),
  mod("lang.numscript"),

  mod("lsp"),
}

local M = {}

function M.setup()
  for _, module in pairs(modules) do
    module.setup()
  end
end

return M
