local utils = require("julienvincent.lsp.utils")

local M = {}

function M.mason_setup_handler(options)
  local jdtls = require("jdtls")

  local registry = require("mason-registry")
  local package = registry.get_package("jdtls")
  local jdtls_install_dir = package:get_install_path()

  local config_dir = "config_mac"
  if vim.fn.has("linux") == 1 then
    config_dir = "config_linux"
  end

  local home_dir = os.getenv("HOME")
  local cwd = vim.fn.getcwd()
  local project_id = vim.fn.sha256(cwd)
  local data_dir = home_dir .. "/.local/share/nvim/jdtls/projects/" .. project_id

  local launcher = utils.find_file_by_glob(jdtls_install_dir .. "/plugins", "org.eclipse.equinox.launcher_*")

  local cmd = {
    "java",

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",

    "-jar",
    launcher,

    "-configuration",
    jdtls_install_dir .. "/" .. config_dir,

    "-data",
    data_dir,
  }

  local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
  local config = vim.tbl_deep_extend("force", {}, options, {
    cmd = cmd,

    init_options = {
      extendedClientCapabilities = vim.tbl_deep_extend("force", {}, extendedClientCapabilities, {
        resolveAdditionalTextEditsSupport = true,
      }),
    },
  })

  local libs = {}
  local project_root = utils.find_furthest_root({ "deps.edn" })(cwd)
  local job_id = nil
  if project_root then
    job_id = utils.find_third_party_libs(project_root, function(project_libs)
      libs = project_libs
    end)
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "java" },
    desc = "Start and attach jdtls",
    callback = function()
      if job_id then
        vim.fn.jobwait({ job_id })
        job_id = nil
      end
      jdtls.start_or_attach(vim.tbl_deep_extend("force", {}, config, {
        settings = {
          java = {
            project = {
              referencedLibraries = libs,
            },
          },
        },
      }))
    end,
  })
end

return M
