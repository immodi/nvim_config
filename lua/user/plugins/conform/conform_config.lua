local M = {}

M.keys = {
	{
		"<leader>f",
		function()
			require("conform").format({
				async = true,
				lsp_format = "fallback",
			})
		end,
		mode = "n", -- Use 'n' for normal mode
		desc = "[F]ormat buffer",
	},
}

M.opts = {
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black", "ast_grep", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
}

return M
