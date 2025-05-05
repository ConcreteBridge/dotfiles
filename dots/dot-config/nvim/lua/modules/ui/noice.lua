require("pckr").add {
  {
    "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        views = {
          cmdline_popup = {
            position = { row = 0, col = "50%" },
            size = { width = "75%" },
          },
        },
      }
    end,
  },
}
