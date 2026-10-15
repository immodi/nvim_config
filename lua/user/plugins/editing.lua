return {
	-- Comment toggling
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = {
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Toggle comment on line",
			},
			{
				"<leader>/",
				function()
					local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
					vim.api.nvim_feedkeys(esc, "nx", false)
					require("Comment.api").toggle.linewise(vim.fn.visualmode())
				end,
				mode = "v",
				desc = "Toggle comment on selection",
			},
		},
		config = function()
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	-- Multiple cursors
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_maps = {
				["Find Under"] = "<C-d>",
				["Add Cursor Up"] = "<S-A-k>",
				["Add Cursor Down"] = "<S-A-j>",
			}
			vim.g.VM_custom_noremaps = { ["<CR>"] = 1 }
			vim.g.VM_mouse_mappings = 1
		end,
	},
}
