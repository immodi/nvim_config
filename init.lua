-- Leader must be set before lazy.nvim loads so plugin `keys` use it
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core config (no plugin dependencies)
require("user.config.options")
require("user.config.keymaps")
require("user.config.autocmds")
require("user.config.diagnostics")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Every file in lua/user/plugins/ is one plugin spec
require("lazy").setup({ { import = "user.plugins" } })
