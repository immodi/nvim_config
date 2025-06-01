-- Leader key
vim.g.mapleader = " "

-- Set shorter CursorHold delay
vim.o.updatetime = 1000

-- jj to escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- redo an action ctrl + u
vim.keymap.set('n', '<C-u>', '<C-r>', { noremap = true })

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
        -- Truncate long messages
        format = function(diagnostic)
            local max_width = 50
            local message = diagnostic.message
            if #message > max_width then
                return message:sub(1, max_width - 3) .. "..."
            end
            return message
        end,
    },
    signs = false, -- Disable signs to avoid duplication
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        max_width = math.floor(vim.o.columns * 0.6),
        wrap = true,
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

-- add code defentions on hover
-- vim.cmd([[
--   autocmd CursorHold * lua vim.lsp.buf.hover()
-- ]])

-- Combined LSP hover and diagnostics on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        -- Check for diagnostics on current line
        local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
        local has_diagnostics = #diagnostics > 0

        -- Check for LSP clients
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local has_lsp = #clients > 0

        if has_diagnostics and has_lsp then
            -- Get LSP hover content first
            local client = clients[1] -- Use first available client
            local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
            vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, config)
                if result and result.contents then
                    local lsp_content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
                    local lsp_text = table.concat(lsp_content, '\n')

                    -- Build diagnostic text
                    local diagnostic_text = ""
                    for _, diagnostic in ipairs(diagnostics) do
                        diagnostic_text = diagnostic_text .. string.format("\n\n🔸 %s: %s",
                            diagnostic.source or "LSP",
                            diagnostic.message)
                    end

                    -- Combine both
                    local combined_content = lsp_text .. diagnostic_text

                    -- Show combined popup
                    local lines = vim.split(combined_content, '\n')
                    vim.lsp.util.open_floating_preview(lines, 'markdown', {
                        border = 'rounded',
                        focusable = false,
                        close_events = { "CursorMoved", "CursorMovedI", "BufHidden" }
                    })
                end
            end)
        elseif has_diagnostics then
            -- Only diagnostics
            vim.diagnostic.open_float(nil, {
                focus = false,
                scope = "cursor",
                close_events = { "CursorMoved", "CursorMovedI" }
            })
        elseif has_lsp then
            -- Only LSP hover
            vim.lsp.buf.hover()
        end
    end,
})

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

-- Move selected lines down with Alt + j (visual mode)
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move selected lines up with Alt + k (visual mode)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Use Telescope for code actions
vim.keymap.set("n", "<leader>ca", function()
    require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

-- Select current line with v + v
vim.keymap.set('n', 'vv', 'V', { desc = 'Select current line in visual mode' })
