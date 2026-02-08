return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    sections = {
      lualine_c = {
        { "filename", path = 3 },
      },
      lualine_x = {
        {
          function()
            return require("opencode").statusline()
          end,
        },
      },
    },
    tabline = {
      lualine_a = { "buffers" },
      lualine_z = { "tabs" },
    },
  },
}
