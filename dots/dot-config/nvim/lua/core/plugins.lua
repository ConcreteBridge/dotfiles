local pckr_path = vim.fn.stdpath "data" .. "/pckr/pckr.nvim"

if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/lewis6991/pckr.nvim",
    pckr_path,
  }
end

vim.opt.rtp:prepend(pckr_path)

require("pckr").add { "forest-nvim/sequoia.nvim", "folke/which-key.nvim" }
require("which-key").setup()
