return {
	"folke/flash.nvim",
	-- VeryLazy, not keys: char mode remaps f/F/t/T/; during setup. Jump keymaps live in
	-- mappings.lua and load the plugin through require("flash")
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
}
