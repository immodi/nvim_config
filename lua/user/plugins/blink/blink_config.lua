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
	-- Fix vim-visual-multi breaking blink.cmp keys
	vim.api.nvim_create_autocmd("User", {
		pattern = "visual_multi_exit",
		callback = function()
			vim.schedule(function()
				-- Force re-setup blink's Enter mapping
				vim.keymap.set("i", "<CR>", function()
					if blink.is_visible() then
						blink.accept()
						return ""
					else
						-- Send actual Enter key press
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
						return ""
					end
				end, { expr = true, replace_keycodes = false })
				-- Force re-setup blink's Up arrow mapping
				vim.keymap.set("i", "<Up>", function()
					if blink.is_visible() then
						blink.select_prev()
						return ""
					else
						-- Send actual Up arrow key press
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "n", false)
						return ""
					end
				end, { expr = true, replace_keycodes = false })
				-- Force re-setup blink's Down arrow mapping
				vim.keymap.set("i", "<Down>", function()
					if blink.is_visible() then
						blink.select_next()
						return ""
					else
						-- Send actual Down arrow key press
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "n", false)
						return ""
					end
				end, { expr = true, replace_keycodes = false })
				-- FIXED: Force re-setup blink's Tab mapping to ONLY insert 4 spaces
				vim.keymap.set("i", "<Tab>", function()
					if blink.is_visible() then
						blink.select_next()
						return ""
					else
						-- CHANGED: Return 4 spaces directly instead of using feedkeys
						return "    "
					end
				end, { expr = true, replace_keycodes = false })
				-- Force re-setup blink's Shift+Tab mapping
				vim.keymap.set("i", "<S-Tab>", function()
					if blink.is_visible() then
						blink.select_prev()
						return ""
					else
						-- Send actual Shift+Tab key press
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
						return ""
					end
				end, { expr = true, replace_keycodes = false })
			end)
		end,
	})
end
return M
