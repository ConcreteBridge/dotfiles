require("pckr").add {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require "lint"
      lint.linters_by_ft = {
        lua = { "luac" },
        python = { "ruff" },
      }
      vim.api.nvim_create_autocmd(
        { "BufWritePost", "BufReadPre", "InsertLeave" },
        { callback = function() require("lint").try_lint() end }
      )
    end,
  },
}
