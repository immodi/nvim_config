local telescope = require("telescope")
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<CR>"] = function(prompt_bufnr)
					-- save buffers before selecting
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if
							vim.api.nvim_buf_is_loaded(buf)
							and vim.bo[buf].modified
							and vim.bo[buf].buftype == ""
							and vim.api.nvim_buf_get_name(buf) ~= ""
						then
							pcall(function()
								vim.api.nvim_buf_call(buf, function()
									vim.cmd("write")
								end)
							end)
						end
					end
					actions.select_default(prompt_bufnr)
				end,
			},
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
})

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
