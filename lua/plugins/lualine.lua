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
    },
    tabline = {
      lualine_a = { "buffers" },
      lualine_z = { "tabs" },
    },
  },
}
