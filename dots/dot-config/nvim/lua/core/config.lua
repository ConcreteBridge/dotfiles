local g = vim.g
local opt = vim.opt
local cmd = vim.cmd

g.mapleader = " "
g.localmapleader = "\\"

-- speedups
opt.updatetime = 250
opt.timeoutlen = 400

-- visual options
opt.conceallevel = 2
opt.infercase = true
opt.shortmess:append "sWcI"
opt.signcolumn = "yes:1"
opt.formatoptions = { "q", "j" }
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- just good defaults
opt.splitright = true
opt.splitbelow = true

-- tab options
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- clipboard and mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- backups are annoying
opt.undofile = true
opt.writebackup = false
opt.swapfile = false

-- external config files
opt.exrc = true

-- search and replace
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

-- better grep
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.path = { ".", "**" }

-- previously nightly options
opt.diffopt:append "linematch:60"
opt.splitkeep = "screen"

-- gui options
opt.list = true
opt.fillchars = {
  eob = " ",
  vert = " ",
  horiz = " ",
  diff = "╱",
  foldclose = "",
  foldopen = "",
  fold = " ",
  msgsep = "─",
}
opt.listchars = {
  tab = "   ",
  -- tab = " ──",
  trail = "·",
  nbsp = "␣",
  precedes = "«",
  extends = "»",
}
opt.scrolloff = 4

opt.termguicolors = true
