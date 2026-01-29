local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Set border colors on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#b4befe" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#b4befe" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#b4befe" })
  end,
})

-- Only highlight when actively searching
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = augroup,
  callback = function()
    local cmd = vim.v.event.cmdtype
    if cmd == "/" or cmd == "?" then
      vim.opt.hlsearch = true
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = augroup,
  callback = function()
    local cmd = vim.v.event.cmdtype
    if cmd == "/" or cmd == "?" then
      vim.opt.hlsearch = false
    end
  end,
})

-- Highlight when yanking
vim.api.nvim_set_hl(0, "YankHighlight", { bg = "#f9e2af", fg = "#000000" })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({
      higroup = "YankHighlight",
      timeout = 200,
    })
  end,
})

-- Disable auto comment on new lines
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Enable spell check for markdown files
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
  end,
})
