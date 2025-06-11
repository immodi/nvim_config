local M = {}

M.dep = {
    {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
            if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                return
            end
            return "make install_jsregexp"
        end)(),
        dependencies = {
            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = {},
    },
    "folke/lazydev.nvim",
}

M.opts = {
    keymap = { preset = "enter" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
            lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
    },
    snippets = { preset = "luasnip" },
    fuzzy = { implementation = "lua" },
    signature = { enabled = true },
}

-- Add this config function to handle VM conflicts
M.config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)
    -- Fix vim-visual-multi breaking blink.cmp Enter key

    vim.api.nvim_create_autocmd("User", {
        pattern = "visual_multi_exit",
        callback = function()
            vim.schedule(function()
                -- Force re-setup blink's Enter mapping
                vim.keymap.set("i", "<CR>", function()
                    if blink.is_visible() then
                        return blink.accept()
                    else
                        return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
                    end
                end, { expr = true, buffer = true })
            end)
        end,
    })
end

return M
