-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Load plugins first
require("user/plugins/plugins")
require("user/plugins/plugins_config")

-- Now load options and keymaps which may depend on plugins
require("user/options")
require("user/keymaps")
