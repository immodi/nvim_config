local builtin = require("telescope.builtin")

-- Leader key
vim.g.mapleader = " "

-- jj to escape insert mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- redo an action ctrl + u
vim.keymap.set("n", "<C-u>", "<C-r>", { noremap = true })

-- Telescope
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Format on save (for buffers attached to an LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- Or map a key to format manually
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end, { desc = "Format file" })

-- Indent with Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })

-- Unindent with Shift-Tab in visual mode
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

-- Go to defention with G-D
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

-- Move current line down with Alt + j
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })

-- Move current line up with Alt + k
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })

-- Move selected lines down with Alt + j (visual mode)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Move selected lines up with Alt + k (visual mode)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Use Telescope for code actions
vim.keymap.set("n", "<leader>ca", function()
	require("tiny-code-action").code_action({})
end, { noremap = true, silent = true })

-- Select current line with v + v
vim.keymap.set("n", "vv", "V", { desc = "Select current line in visual mode" })

-- highlight the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch", -- You can change this highlight group
			timeout = 200, -- Duration in milliseconds
		})
	end,
})

-- Toggle comment in Normal mode with <leader>/
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment on current line" })

-- Toggle comment in Visual mode with <leader>/
vim.keymap.set("v", "<leader>/", function()
	local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment on selection" })
