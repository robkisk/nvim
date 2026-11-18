return {
	"folke/snacks.nvim",
	-- Every module enabled here is on-demand (keymaps in mappings.lua); eager load is
	-- snacks' own recommendation, and claudecode.nvim loads it at VeryLazy regardless
	priority = 1000,
	lazy = false,
	opts = {
		gh = {},
		gitbrowse = {
			-- Lists replace snacks' defaults instead of merging, so this is the default
			-- list with one entry prepended: EMU repos' insteadOf rules rewrite remotes to
			-- the `github.com-emu` SSH alias, which would otherwise yield https://github.com-emu/...
			-- stylua: ignore
			remote_patterns = {
				{ "^git@github%.com%-[%w_-]+:"        , "git@github.com:" },
				{ "^(https?://.*)%.git$"              , "%1" },
				{ "^git@(.+):(.+)%.git$"              , "https://%1/%2" },
				{ "^git@(.+):(.+)$"                   , "https://%1/%2" },
				{ "^git@(.+)/(.+)$"                   , "https://%1/%2" },
				{ "^org%-%d+@(.+):(.+)%.git$"         , "https://%1/%2" },
				{ "^ssh://git@(.*)$"                  , "https://%1" },
				{ "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
				{ "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
				{ "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
				{ "^https://%w*@(.*)"                 , "https://%1" },
				{ "^git@(.*)"                         , "https://%1" },
				{ ":%d+"                              , "" },
				{ "%.git$"                            , "" },
			},
		},
		lazygit = {},
		-- gh needs the picker enabled. ui_select stays off: fzf-lua already owns
		-- vim.ui.select (register_ui_select in fzf.lua)
		picker = { ui_select = false },
		scratch = {},
		zen = {},
	},
}
