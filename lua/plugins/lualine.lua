return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    tabline = {
      lualine_a = { "buffers" },
      lualine_z = { "tabs" },
    },
  },
}
