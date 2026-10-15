return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader><leader>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
		{ "<leader>lg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
		{ "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
		{ "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
	},
	config = function()
		local actions = require("telescope.actions")

		-- Save all modified file buffers before opening the selection
		local function save_then_select(prompt_bufnr)
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if
					vim.api.nvim_buf_is_loaded(buf)
					and vim.bo[buf].modified
					and vim.bo[buf].buftype == ""
					and vim.api.nvim_buf_get_name(buf) ~= ""
				then
					pcall(vim.api.nvim_buf_call, buf, function()
						vim.cmd("write")
					end)
				end
			end
			actions.select_default(prompt_bufnr)
		end

		require("telescope").setup({
			defaults = {
				mappings = { i = { ["<CR>"] = save_then_select } },
			},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
	end,
}
