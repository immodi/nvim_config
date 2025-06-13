-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.o.mouse = ""

-- Set shorter CursorHold delay
vim.o.updatetime = 1000

-- Tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4 -- Added for proper backspace behavior
vim.opt.smartindent = false

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

-- Disable wildmenu tab completion to prevent Tab from jumping around in command mode
vim.opt.wildmenu = false
vim.opt.wildmode = ""

vim.cmd([[colorscheme tokyonight-storm]])

-- Clipboard
vim.opt.clipboard = "unnamedplus"

vim.lsp.enable({
    "lua_ls",   -- Lua (lua-language-server)
    "pyright",  -- Python
    "html",     -- HTML
    "templ",    -- Templ (templ)
    "tsserver", -- JavaScript/TypeScript (typescript-language-server)
    "tailwindcss", -- Tailwind CSS
    "cssls",    -- CSS (css-lsp)
    "eslint",   -- ESLint
    "gopls",    -- Go
})
