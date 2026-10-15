local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Mouse off
opt.mouse = ""

-- Faster CursorHold (drives the hover/diagnostic popup)
opt.updatetime = 1000

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false

-- Disable wildmenu so Tab doesn't jump around in command mode
opt.wildmenu = false
opt.wildmode = ""

-- Clipboard
opt.clipboard = "unnamedplus"
