return {
  --lvim.builtin.nvimtree.setup.update_focused_file.enable = false
  --lvim.builtin.nvimtree.setup.update_focused_file.update_root = false --do not change root when symlink is opened
  "nvim-tree/nvim-tree.lua",
  opts = {
    filters = {
      custom = { "^\\.git$", "^\\.github$" },
      git_ignored = false,
    },
    live_filter = {
      prefix = "F clears:",
    },
    git = {
      enable = true,
    },
    view = {
      width = 30,
    },
    renderer = {
      symlink_destination = false,
      icons = {
        show = {
          git = true,
          folder_arrow = false,
        },
      },
    },
    hijack_directories = {
      enable = true,
    },
    update_focused_file = {
      enable = false,
    },
  },
}
