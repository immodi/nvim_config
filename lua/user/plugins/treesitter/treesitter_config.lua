local treesitterConfig = require("nvim-treesitter.configs")

treesitterConfig.setup({
    ensure_installed = {
        "lua",
        "python",
        "html",
        "templ",
        "javascript",
        "typescript",
        "css",
        "tsx",
        "svelte",
        "kotlin",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    auto_install = false,
})
