return {
	"nvim-tree/nvim-tree.lua",
	-- Loads on its commands, except for `nvim <dir>`: then it loads at startup so the tree
	-- replaces netrw. A directory opened later with :edit gets netrw until the tree has loaded.
	lazy = vim.fn.argc(-1) == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 0,
	-- Every command nvim-tree defines, so none of them is E492 before the tree has loaded
	cmd = {
		"NvimTreeClipboard",
		"NvimTreeClose",
		"NvimTreeCollapse",
		"NvimTreeCollapseKeepBuffers",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeFocus",
		"NvimTreeHiTest",
		"NvimTreeOpen",
		"NvimTreeRefresh",
		"NvimTreeResize",
		"NvimTreeToggle",
	},
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
		})
	end,
}
