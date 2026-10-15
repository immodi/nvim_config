-- vim-visual-multi clobbers insert-mode maps when it exits, which breaks blink.cmp.
-- Re-apply the keys we care about after VM exits.
local function reapply_insert_keys(blink)
	-- When the menu is visible run `on_visible`, otherwise return `fallback` as typed keys
	local function map(lhs, on_visible, fallback)
		vim.keymap.set("i", lhs, function()
			if blink.is_visible() then
				on_visible()
				return ""
			end
			return fallback
		end, { expr = true })
	end

	map("<CR>", blink.accept, "<CR>")
	map("<Up>", blink.select_prev, "<Up>")
	map("<Down>", blink.select_next, "<Down>")
	map("<Tab>", blink.select_next, "    ") -- Tab inserts 4 spaces when the menu is closed
	map("<S-Tab>", blink.select_prev, "<S-Tab>")
end

return {
	"saghen/blink.cmp",
	priority = 1000,
	event = "VimEnter",
	version = "1.*",
	dependencies = {
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
	},
	opts = {
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
	},
	config = function(_, opts)
		local blink = require("blink.cmp")
		blink.setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "visual_multi_exit",
			callback = function()
				vim.schedule(function()
					reapply_insert_keys(blink)
				end)
			end,
		})
	end,
}
