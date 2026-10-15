-- Core keymaps. Plugin keymaps live next to their plugin spec (lua/user/plugins/*)
-- and LSP keymaps are set on LspAttach (lua/user/plugins/lsp.lua).
local map = vim.keymap.set

-- Typos for write/quit
for _, cmd in ipairs({ "W", "Wq", "WQ", "Q" }) do
	vim.api.nvim_create_user_command(cmd, cmd:lower(), {})
end

-- Don't suspend nvim with Ctrl+Z
map({ "n", "v", "i" }, "<C-z>", "<nop>")

-- Insert mode
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Normal mode
map("n", "<C-u>", "<C-r>", { desc = "Redo" })
map("n", "<C-a>", "ggVG", { desc = "Select entire file" })
map("n", "vv", "V", { desc = "Select current line" })
map("n", "cb", "v%", { remap = false, desc = "Select matching block" })
map("n", "<leader>q", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

map("n", "sr", function()
	local old = vim.fn.input("Replace in file - Search for: ")
	if old == "" then
		return
	end
	local new = vim.fn.input("Replace with: ")
	if new == "" then
		return
	end
	-- escape slashes so they don't break the substitution
	old = vim.fn.escape(old, "/\\")
	new = vim.fn.escape(new, "/\\")
	vim.cmd("%s/" .. old .. "/" .. new .. "/g")
end, { desc = "File-wide replace" })

-- Move lines with Alt+j / Alt+k
map("n", "<A-j>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Indent with Tab / Shift-Tab in visual mode
map("v", "<Tab>", ">gv", { silent = true, desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { silent = true, desc = "Unindent selection" })
