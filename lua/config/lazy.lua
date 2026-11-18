-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Ghostty.app ships Neovim runtime files for its config (filetype, syntax, and
-- `:compiler ghostty` running +validate-config) and exposes them through
-- $XDG_DATA_DIRS, which lazy's rtp reset drops. Keep that dir on the rtp explicitly.
local ghostty_runtime = "/Applications/Ghostty.app/Contents/Resources/nvim/site"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
	-- No plugin here needs luarocks; skip hererocks setup and its checkhealth warnings
	rocks = { enabled = false },
	performance = {
		rtp = { paths = vim.fn.isdirectory(ghostty_runtime) == 1 and { ghostty_runtime } or {} },
	},
})

-- Set the autoread option to allow Neovim to notice when a file has changed on disk
vim.opt.autoread = true

-- Use autocmds to check for changes on various events
vim.api.nvim_create_autocmd({ "FocusGained", "TermLeave", "BufEnter", "WinEnter", "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("CheckFileChanges", { clear = true }),
	callback = function()
		-- Check if the current buffer is unmodified within Neovim before reloading.
		-- Skip the cmdline window (`q:`): checktime there raises E11 on BufEnter.
		if vim.fn.getcmdwintype() == "" and not vim.bo.modified and vim.bo.modifiable then
			vim.cmd("checktime")
		end
	end,
})

-- Optional: Add a notification when a file has been reloaded
vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
	group = vim.api.nvim_create_augroup("FileReloadNotification", { clear = true }),
	callback = function()
		vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO, {})
	end,
})
