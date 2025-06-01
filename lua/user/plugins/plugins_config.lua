local cmp = require("cmp")
local luasnip = require("luasnip")
local treesitterConfig = require('nvim-treesitter.configs')
local telescope = require("telescope")
local actions = require("telescope.actions")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
})


treesitterConfig.setup {
    ensure_installed = {
        "lua",
        "python",
        "html",
        "templ",
        "javascript",
        "typescript",
        "css",
        "tsx",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

telescope.setup {
    defaults = {
        mappings = {
            i = {
                ["<CR>"] = function(prompt_bufnr)
                    -- Save all modified buffers BEFORE switching
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(buf) and
                            vim.bo[buf].modified and
                            vim.bo[buf].buftype == "" and
                            vim.api.nvim_buf_get_name(buf) ~= "" then
                            -- Use pcall to safely save each buffer
                            pcall(function()
                                vim.api.nvim_buf_call(buf, function()
                                    vim.cmd("write")
                                end)
                            end)
                        end
                    end
                    actions.select_default(prompt_bufnr)
                end,
            },
        },
    },
}
