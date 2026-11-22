return {
	-- Justfile syntax, ftplugin, and indent (github.com/NoahTheDuke/vim-just), newer than the
	-- copies Neovim 0.12 bundles. lazy sources an ft-loaded plugin's ftdetect at startup, so
	-- its detection still covers what Neovim's own misses (`*.justfile`) before it loads.
	"NoahTheDuke/vim-just",
	ft = "just",
}
