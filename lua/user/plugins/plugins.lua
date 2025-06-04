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
        -- {
        -- 	"nvim-telescope/telescope.nvim",
        -- 	tag = "0.1.8",
        -- 	dependencies = { "nvim-lua/plenary.nvim" },
        -- },

        { -- Fuzzy Finder (files, lsp, etc)
            "nvim-telescope/telescope.nvim",
            event = "VimEnter",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { -- If encountering errors, see telescope-fzf-native README for installation instructions
                    "nvim-telescope/telescope-fzf-native.nvim",

                    -- `build` is used to run some command when the plugin is installed/updated.
                    -- This is only run then, not every time Neovim starts up.
                    build = "make",

                    -- `cond` is a condition used to determine whether this plugin should be
                    -- installed and loaded.
                    cond = function()
                        return vim.fn.executable("make") == 1
                    end,
                },
                { "nvim-telescope/telescope-ui-select.nvim" },

                -- Useful for getting pretty icons, but requires a Nerd Font.
                {
                    "nvim-tree/nvim-web-devicons",
                    enabled = vim.g.have_nerd_font,
                },
            },
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

        {
            "numToStr/Comment.nvim",
            dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
            config = function()
                require("Comment").setup({
                    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
                })
            end,
        },
    }
)
