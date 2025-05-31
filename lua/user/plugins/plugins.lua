return require("lazy").setup({
    -- Theme
    -- { "rebelot/kanagawa.nvim",    lazy = false },
    { "ellisonleao/gruvbox.nvim", lazy = false },

    -- Status line
    { "nvim-lualine/lualine.nvim" },

    --File explorer
    { "nvim-tree/nvim-tree.lua" },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },

    -- Completion framework
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",     -- LSP completion source
            "hrsh7th/cmp-buffer",       -- Buffer words completion
            "hrsh7th/cmp-path",         -- Filesystem paths completion
            "hrsh7th/cmp-cmdline",      -- Command line completion
            "saadparwaiz1/cmp_luasnip", -- Snippet completions
            "L3MON4D3/LuaSnip",         -- Snippet engine
        }
    },

    -- LSP configuration
    { "neovim/nvim-lspconfig" },

    -- Mason for managing LSP servers
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = true,
    },

    -- Mason integration with lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "html",
                    "cssls",
                    "templ",
                    "ts_ls",
                    'eslint',
                },

                automatic_installation = true,
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" }, -- Recognize `vim` as a global
                                    },
                                }
                            }
                        })
                    end,

                    ["templ"] = function()
                        require("lspconfig").templ.setup({
                            capabilities = capabilities,
                            filetypes = { "templ" }, -- explicitly state supported filetypes
                        })
                    end,
                }
            })
        end,
    },

    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "ibhagwan/fzf-lua" },
            {
                "folke/snacks.nvim",
                opts = {
                    terminal = {},
                }
            }
        },
        event = "LspAttach",
        opts = {},
    },
})
