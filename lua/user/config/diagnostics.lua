-- Diagnostic display + combined hover/diagnostic popup on CursorHold

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 2,
		severity = { min = vim.diagnostic.severity.WARN },
		source = "if_many",
		format = function(diagnostic)
			local max_width = 50
			local message = diagnostic.message
			if #message > max_width then
				return message:sub(1, max_width - 3) .. "..."
			end
			return message
		end,
	},
	signs = false,
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

vim.api.nvim_create_autocmd("CursorHold", {
	group = vim.api.nvim_create_augroup("user-cursorhold-info", { clear = true }),
	callback = function()
		local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		local has_diagnostics = #diagnostics > 0
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		local has_lsp = #clients > 0

		if has_diagnostics and has_lsp then
			-- LSP hover + diagnostics in one popup
			local client = clients[1]
			local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
			vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result)
				if not (result and result.contents) then
					return
				end
				local text = table.concat(vim.lsp.util.convert_input_to_markdown_lines(result.contents), "\n")
				for _, d in ipairs(diagnostics) do
					text = text .. string.format("\n\n🔸 %s: %s", d.source or "LSP", d.message)
				end
				vim.lsp.util.open_floating_preview(vim.split(text, "\n"), "markdown", {
					border = "rounded",
					focusable = false,
					close_events = { "CursorMoved", "CursorMovedI", "BufHidden" },
				})
			end)
		elseif has_diagnostics then
			vim.diagnostic.open_float(nil, {
				focus = false,
				scope = "cursor",
				close_events = { "CursorMoved", "CursorMovedI" },
			})
		elseif has_lsp then
			vim.lsp.buf.hover()
		end
	end,
})
