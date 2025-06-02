local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<CR>"] = function(prompt_bufnr)
					-- Save all modified buffers BEFORE switching
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if
							vim.api.nvim_buf_is_loaded(buf)
							and vim.bo[buf].modified
							and vim.bo[buf].buftype == ""
							and vim.api.nvim_buf_get_name(buf) ~= ""
						then
							-- Use pcall to safely save each buffer
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
})
