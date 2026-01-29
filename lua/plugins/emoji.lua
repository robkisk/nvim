return {
  "Allaman/emoji.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {},
  keys = {
    { "<leader>se", "<cmd>Emoji<cr>", desc = "Search Emoji" },
    { "<leader>sk", "<cmd>Emoji kaomoji<cr>", desc = "Search Kaomoji" },
  },
}
