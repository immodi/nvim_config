local cmp = require("cmp")
local luasnip = require("luasnip")
local treesitterConfig = require('nvim-treesitter.configs')

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
    ensure_installed = { "lua", "python", "html", "templ" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
