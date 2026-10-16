-- AI inline completion (ghost text), powered by Windsurf/Codeium.
-- Uses neocodeium, a free Codeium completion plugin.
--
-- Setup:
--   Run `:NeoCodeium auth` once to log in and save the API token.
--   Use `:NeoCodeium toggle` to enable/disable on the fly.
return {
	"monkoose/neocodeium",
	event = "VeryLazy",
	opts = {
		-- Lowest-latency settings.
		-- `true` would batch keystrokes and delay suggestions; keep it off.
		debounce = false,
		-- Context lines parsed from *other* loaded buffers. Lower = less parsing
		-- and a smaller request payload = snappier. The current buffer is always
		-- fully parsed. Set to 0 for the fastest, lowest-quality option.
		max_lines = 1000,
		-- Set to true to collapse multi-line suggestions to a single line, which
		-- plays nicer with the blink.cmp menu.
		-- single_line = { enabled = true },
	},
	config = function(_, opts)
		local neocodeium = require("neocodeium")
		neocodeium.setup(opts)

		-- Accept the whole suggestion with <Tab><Tab>. When no ghost text is visible
		-- the two Tabs behave normally (or move through the completion menu if it is
		-- open).
		vim.keymap.set("i", "<Tab><Tab>", function()
			if neocodeium.visible() then
				neocodeium.accept()
				return ""
			end
			local blink = require("blink.cmp")
			if blink.is_visible() then
				blink.select_next()
				blink.select_next()
				return ""
			end
			return "<Tab><Tab>"
		end, { expr = true, replace_keycodes = true, desc = "AI: accept suggestion (Tab Tab)" })

		vim.keymap.set("i", "<A-l>", neocodeium.accept_line, { desc = "AI: accept line" })
		vim.keymap.set("i", "<A-w>", neocodeium.accept_word, { desc = "AI: accept word" })
		vim.keymap.set("i", "<A-]>", function()
			neocodeium.cycle_or_complete(1)
		end, { desc = "AI: next suggestion" })
		vim.keymap.set("i", "<A-[>", function()
			neocodeium.cycle_or_complete(-1)
		end, { desc = "AI: previous suggestion" })
		vim.keymap.set("i", "<A-e>", neocodeium.clear, { desc = "AI: dismiss suggestion" })
	end,
}
