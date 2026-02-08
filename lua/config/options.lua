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

-- Filetype associations
vim.filetype.add({
	filename = {
		[".databrickscfg"] = "sh",
	},
	pattern = {
		["%.env"] = "sh",
		["%.env%..*"] = "sh",
	},
})

