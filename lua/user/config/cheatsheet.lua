-- Keybinds cheat sheet: press <leader>? (or run :Keybinds) to open it in a floating window.
-- Press q or <Esc> to close it. For a live, searchable list of every mapping use <leader>fk.
-- Keep this list in sync when you add or change a keymap.

local sections = {
	{
		"Core",
		{
			{ "jj", "i", "Exit insert mode" },
			{ "<C-u>", "n", "Redo" },
			{ "<C-a>", "n", "Select entire file" },
			{ "vv", "n", "Select current line" },
			{ "cb", "n", "Select matching block" },
			{ "sr", "n", "File-wide replace (asks for search + replacement)" },
			{ "<A-j> / <A-k>", "n v", "Move line / selection down / up" },
			{ "<Tab> / <S-Tab>", "v", "Indent / unindent selection" },
			{ "<leader>q", "n", "Close quickfix list" },
			{ "<C-z>", "n v i", "Disabled (no suspend)" },
			{ ":W :Wq :WQ :Q", "cmd", "Typo-friendly aliases for :w :wq :q" },
		},
	},
	{
		"AI completion (neocodeium)",
		{
			{ "<Tab><Tab>", "i", "Accept whole suggestion" },
			{ "<A-l>", "i", "Accept one line of the suggestion" },
			{ "<A-w>", "i", "Accept one word of the suggestion" },
			{ "<A-]> / <A-[>", "i", "Next / previous suggestion (also triggers one)" },
			{ "<A-e>", "i", "Dismiss suggestion" },
		},
	},
	{
		"Completion menu (blink.cmp)",
		{
			{ "<CR>", "i", "Accept selected item" },
			{ "<Tab> / <Down>", "i", "Select next item (4 spaces if menu closed)" },
			{ "<S-Tab> / <Up>", "i", "Select previous item" },
		},
	},
	{
		"Find (telescope)",
		{
			{ "<leader><leader>", "n", "Find files" },
			{ "<leader>lg", "n", "Live grep" },
			{ "<leader>fb", "n", "Buffers" },
			{ "<leader>fh", "n", "Help tags" },
			{ "<leader>fk", "n", "Search all keymaps" },
			{ "<CR> (in picker)", "i", "Save modified buffers, then open selection" },
		},
	},
	{
		"Harpoon",
		{
			{ "<leader>h", "n", "Quick menu" },
			{ "<leader>hc", "n", "Add current file" },
			{ "<leader>1 .. <leader>4", "n", "Jump to harpoon file 1-4" },
			{ "<leader>[ / <leader>]", "n", "Previous / next mark" },
		},
	},
	{
		"Editing",
		{
			{ "<leader>/", "n v", "Toggle comment (line / selection)" },
			{ "<leader>f", "n", "Format buffer" },
			{ "<C-d>", "n v", "Multi-cursor: select word under cursor / next match" },
			{ "<S-A-k> / <S-A-j>", "n", "Multi-cursor: add cursor up / down" },
		},
	},
	{
		"LSP (when a server is attached)",
		{
			{ "gd", "n", "Go to definition" },
			{ "gI", "n", "Go to implementation" },
			{ "grn", "n", "Rename" },
			{ "gra", "n x", "Code action" },
			{ "<leader>ca", "n", "Code action (picker)" },
			{ "grr", "n", "References" },
			{ "gri", "n", "Implementations" },
			{ "grd", "n", "Definitions" },
			{ "grD", "n", "Declaration" },
			{ "grt", "n", "Type definition" },
			{ "gO", "n", "Document symbols" },
			{ "gW", "n", "Workspace symbols" },
			{ "<leader>th", "n", "Toggle inlay hints" },
		},
	},
	{
		"This page",
		{
			{ "<leader>?", "n", "Open / close this cheat sheet" },
			{ "q / <Esc>", "-", "Close it" },
		},
	},
}

local function build_lines()
	local lines = { "  KEYBINDS    (leader = <Space>)", "" }
	local highlights = { { 0, "Title" } }
	for _, section in ipairs(sections) do
		table.insert(lines, "  " .. section[1])
		table.insert(highlights, { #lines - 1, "Special" })
		for _, row in ipairs(section[2]) do
			table.insert(lines, string.format("    %-26s %-6s %s", row[1], row[2], row[3]))
			table.insert(highlights, { #lines - 1, "Normal", row })
		end
		table.insert(lines, "")
	end
	return lines, highlights
end

local win

local function close()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_close(win, true)
	end
	win = nil
end

local function open()
	if win and vim.api.nvim_win_is_valid(win) then
		return close()
	end

	local lines, highlights = build_lines()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local ns = vim.api.nvim_create_namespace("user-cheatsheet")
	for _, h in ipairs(highlights) do
		if h[3] then
			vim.api.nvim_buf_add_highlight(buf, ns, "Function", h[1], 4, 30) -- key column
			vim.api.nvim_buf_add_highlight(buf, ns, "Comment", h[1], 30, 37) -- mode column
		else
			vim.api.nvim_buf_add_highlight(buf, ns, h[2], h[1], 0, -1)
		end
	end

	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(94, vim.o.columns - 4)
	local height = math.min(#lines, vim.o.lines - 6)
	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2) - 1,
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " Keybinds ",
		title_pos = "center",
	})
	vim.wo[win].cursorline = true

	for _, key in ipairs({ "q", "<Esc>", "<leader>?" }) do
		vim.keymap.set("n", key, close, { buffer = buf, nowait = true, desc = "Close cheat sheet" })
	end
	vim.api.nvim_create_autocmd("BufLeave", { buffer = buf, once = true, callback = close })
end

vim.keymap.set("n", "<leader>?", open, { desc = "Show keybinds cheat sheet" })
vim.api.nvim_create_user_command("Keybinds", open, {})
