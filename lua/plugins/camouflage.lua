return {
	"zeybek/camouflage.nvim",
	-- BufReadPost, not the BufReadPre its README suggests: set up during BufReadPre,
	-- camouflage builds that buffer's Tree-sitter parser before the file is read, so the
	-- tree stays empty and JSON/YAML/TOML values go unmasked. BufReadPost still runs
	-- before the first draw.
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- ~/.claude.json is ~15k lines and holds MCP env secrets; the 5000 default skips it.
		-- Parsing it costs ~250ms per open or reload.
		max_lines = 20000,
		-- ~/.databrickscfg is INI-shaped, but no built-in parser claims its name
		custom_patterns = {
			{
				file_pattern = { ".databrickscfg" },
				pattern = "^%s*([%w_]+)%s*=%s*(.-)%s*$",
				key_capture = 1,
				value_capture = 2,
			},
		},
		policy = {
			-- The default ("mask") hides every parsed value: all of package.json and every
			-- YAML/TOML config, and camouflage turns nvim-cmp off in each masked buffer. Mask
			-- secrets only. :CamouflagePresent doesn't override the policy, so the demo-mode
			-- keymap (<Leader>kp) flips default_action back to "mask" for the demo.
			-- Rules are first-match-wins.
			default_action = "ignore",
			rules = {
				-- Every value in these files. Basename, not parser = "env": the env parser
				-- also claims *.sh scripts. .databrickscfg hosts can name customers.
				{
					id = "whole-file",
					action = "mask",
					basename = { ".env", ".env.*", "*.env", ".envrc", ".databrickscfg" },
				},
				{
					id = "secret-keys",
					action = "mask",
					ignore_case = true,
					-- "token$", not "token": max_tokens / inputTokens counters are everywhere
					key = {
						"token$",
						"secret",
						"passw",
						"api[_%.%-]?key",
						"private[_%.%-]?key",
						"access[_%.%-]?key",
						"credential",
						"authorization",
						"bearer",
						"cookie",
					},
				},
				-- Known token prefixes, for secrets under ordinary keys or in args lists.
				-- "eyJ" is a JWT header; camouflage's own jwt_like shape also matches 1.0.0.
				{
					id = "secret-values",
					action = "mask",
					value_prefix = {
						"dapi",
						"dose",
						"sk-",
						"fc-",
						"ghp_",
						"gho_",
						"ghs_",
						"github_pat_",
						"xoxb-",
						"xoxp-",
						"AKIA",
						"AIza",
						"ya29.",
						"eyJ",
					},
				},
			},
		},
	},
}
