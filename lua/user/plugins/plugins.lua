return require("lazy").setup(
---@diagnostic disable-next-line: missing-fields
    {
        -- Theme
        {
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
        },

        -- Status line
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },

        -- Fuzzy finder
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
        },

        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
        },

        -- LSP Plugins
        {
            -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            },
        },
        {
            -- Main LSP Configuration
            "neovim/nvim-lspconfig",
            dependencies = {
                -- Automatically install LSPs and related tools to stdpath for Neovim
                -- Mason must be loaded before its dependents so we need to set it up here.
                -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
                { "mason-org/mason.nvim", opts = {} },
                "mason-org/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",

                -- Useful status updates for LSP.
                { "j-hui/fidget.nvim",    opts = {} },

                -- Allows extra capabilities provided by blink.cmp
                "saghen/blink.cmp",
            },
            config = require("user.plugins.nvim_lsp.nvim_lsp_config").setup,
        },

        { -- Autoformat
            "stevearc/conform.nvim",
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
            keys = require("user.plugins.conform.conform_config").keys,
            opts = require("user.plugins.conform.conform_config").opts,
        },

        { -- Autocompletion
            "saghen/blink.cmp",
            event = "VimEnter",
            version = "1.*",
            dependencies = require("user.plugins.blink.blink_config").dep,
            opts = require("user.plugins.blink.blink_config").opts,
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
                    },
                },
            },
            event = "LspAttach",
            opts = {},
        },
    }
)
