-- Harpoon (v1)
local function ui()
	return require("harpoon.ui")
end

local keys = {
	{ "<leader>h", function() ui().toggle_quick_menu() end, desc = "Harpoon: quick menu" },
	{ "<leader>hc", function() require("harpoon.mark").add_file() end, desc = "Harpoon: add current file" },
	{ "<leader>[", function() ui().nav_prev() end, desc = "Harpoon: previous mark" },
	{ "<leader>]", function() ui().nav_next() end, desc = "Harpoon: next mark" },
}
for i = 1, 4 do
	table.insert(keys, {
		"<leader>" .. i,
		function()
			ui().nav_file(i)
		end,
		desc = "Harpoon: file " .. i,
	})
end

return {
	"theprimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = keys,
}
