-- [[ Setting options ]]
-- See `:help vim.o`

vim.opt.guicursor = ""

-- Relative numbers allow easier navigation
vim.opt.nu = true
vim.opt.relativenumber = true

-- Just complex tab to spaces and nottab
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.o.breakindent = true

-- Wrapping is weird for code
vim.opt.wrap = false

-- This allows persisting undotree across sessions
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Make sure you can see search one at the time
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Use all terminal colors
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "80"

vim.opt.cursorline = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- vim: ts=2 sts=2 sw=2 et
