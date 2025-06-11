local M = {}

M.init = function()
	vim.g.VM_maps = {
		["Find Under"] = "<C-d>",
		["Add Cursor Up"] = "<S-A-k>",
		["Add Cursor Down"] = "<S-A-j>",
	}
	vim.g.VM_custom_noremaps = { ["<CR>"] = 1 }
	vim.g.VM_mouse_mappings = 1
end

return M
