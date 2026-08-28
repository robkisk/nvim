return {
	-- Justfile syntax + ftdetect (github.com/NoahTheDuke/vim-just).
	-- Loaded eagerly rather than `ft = "just"`: the plugin's own ftdetect
	-- covers cases Neovim's built-in detection misses (`*.justfile`,
	-- `#!/usr/bin/env just` shebang scripts). Lazy-loading on `ft` would never
	-- fire for those — nothing would set the filetype to trigger the load.
	-- Cost is negligible; it only registers syntax + ftdetect autocmds.
	"NoahTheDuke/vim-just",
}
