require("pckr").add {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        format_on_save = { timeout_ms = 750 },
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "ruff" },
        },
      }
    end,
  },
}
