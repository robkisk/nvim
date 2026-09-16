vim.opt.mousemoveevent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 0
vim.opt.splitkeep = "screen"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
-- vim.opt.cursorlineopt = "number"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus" -- sync yank/paste with the system clipboard

-- Filetype associations
vim.filetype.add({
	filename = {
		[".databrickscfg"] = "sh",
		[".gitmessage"] = "gitcommit",
	},
	pattern = {
		["%.env"] = "sh",
		["%.env%..*"] = "sh",
		-- Nvim only auto-detects the exact name `.gitconfig`. This catches the
		-- includes it pulls in: themes.gitconfig, .gitconfig-databricks-field-eng, etc.
		-- Pattern keys are anchored to the full path, so `.gitconfig` needs `.*` on both sides.
		[".*%.gitconfig.*"] = "gitconfig",
	},
})

