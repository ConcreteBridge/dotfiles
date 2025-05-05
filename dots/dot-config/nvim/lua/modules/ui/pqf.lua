require("pckr").add {
  {
    "yorickpeterse/nvim-pqf",
    config = function() require("pqf").setup() end,
  },
}
