-- Leader key
vim.g.mapleader = " "

-- jj to escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Telescope
local ok, builtin = pcall(require, "telescope.builtin")
if ok then
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
end

-- Format on save (for buffers attached to an LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Or map a key to format manually
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end, { desc = "Format file" })


-- Show warnings beside the text
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
        severity = { min = vim.diagnostic.severity.WARN },
        source = "if_many",
    },
    signs = false, -- Disable signs to avoid duplication

    underline = true,
    update_in_insert = false,
    severity_sort = true,

    -- Reduce update frequency to improve performance
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        format = function(diagnostic)
            return string.format("%s: %s", diagnostic.source, diagnostic.message)
        end,
    },
})


-- highlight the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank {
            higroup = "IncSearch", -- You can change this highlight group
            timeout = 200          -- Duration in milliseconds
        }
    end,
})

-- Set shorter CursorHold delay
-- add code defentions on hover
vim.o.updatetime = 600
vim.cmd([[
  autocmd CursorHold * lua vim.lsp.buf.hover()
]])

-- Indent with Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })

-- Unindent with Shift-Tab in visual mode
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Go to defention with G-D
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })

-- Move current line down with Alt + j
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })

-- Move current line up with Alt + k
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })

-- Use Telescope for code actions
vim.keymap.set("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
end, { noremap = true, silent = true })
