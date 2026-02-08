local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap == nil and true or opts.noremap
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better up/down (handle wrapped lines)
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true, desc = "Move down (wrap-aware)" })

vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true, desc = "Move up (wrap-aware)" })

-- Leader commands
map("n", "<Leader>w", ":write<CR>", { desc = "Write buffer" })
map("n", "<Leader>s", ":source %<CR>", { desc = "Source current file" })

-- System clipboard
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<Leader>Y", '"+y$', { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<Leader>P", '"+P', { desc = "Paste before from clipboard" })

-- File explorer (nvim-tree)
map("n", "<Leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<Leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Fuzzy finder (fzf-lua)
map("n", "<Leader>f", function()
	require("fzf-lua").files()
end, { desc = "Find files" })

map("n", "<Leader>g", function()
	require("fzf-lua").live_grep()
end, { desc = "Live grep" })

map("n", "<Leader>G", function()
	require("fzf-lua").grep_curbuf()
end, { desc = "Grep Current Buff" })

map("n", "<Leader>h", function()
	require("fzf-lua").help_tags()
end, { desc = "Search help tags" })

map("n", "<Leader>v", function()
	require("fzf-lua").files({ cwd = "~/.config/nvim" })
end, { desc = "Find nvim config files" })

map("n", "<Leader>b", function()
	require("fzf-lua").buffers()
end, { desc = "Find buffers" })

-- Markdown
map("n", "<Leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown rendering" })

-- Buffer navigation
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"
