return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black", "ast_grep", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},
}
