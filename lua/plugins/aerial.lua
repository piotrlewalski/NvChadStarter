return {
  "stevearc/aerial.nvim",
  opts = {
    layout = {
      default_direction = "left",
      placement = "window",
      width = 30,
    },
    manage_folds = true,
    on_attach = function(bufnr) end,
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
}
