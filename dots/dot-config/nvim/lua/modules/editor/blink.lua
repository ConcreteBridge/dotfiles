require("pckr").add {
  {
    "saghen/blink.cmp",
    requires = { "rafamadriz/friendly-snippets" },
    tag = "v1.*",
    config = function()
      require("blink.cmp").setup { keymap = { preset = "default" } }
    end,
  },
}
