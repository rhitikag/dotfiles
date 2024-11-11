-- ~/.config/nvim/lua/plugins/java.lu
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim", -- Mason for managing language servers
    "williamboman/mason-lspconfig.nvim", -- Integration with lspconfig
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup()
    mason_lspconfig.setup({
      ensure_installed = { "jdtls" },
    })

    lspconfig.jdtls.setup({
      cmd = { "jdtls" },
      root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-11",
                path = "/usr/lib/jvm/java-11-openjdk", -- Path to JDK 11
              },
            },
          },
        },
      },
    })
  end,
}
