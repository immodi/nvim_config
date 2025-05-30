-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.o.mouse = ""

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false

--vim.cmd.colorscheme("kanagawa")
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")

-- Clipboard
vim.opt.clipboard = "unnamedplus"
