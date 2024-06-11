return { -- Rename, hover, etc.
  "jinzhongjia/LspUI.nvim",
  event = "LspAttach",
  opts = {
    lightbulb = { enable = false },
    code_action = {
      enable = true,
      command_enable = true,
      gitsigns = true,
      key_binding = {
        exec = "<CR>",
        prev = "k",
        next = "j",
        quit = "<Esc>",
      },
    },
    pos_keybind = {
      main = {
        back = "<leader>l", -- back to secondary view
        hide_secondary = "<leader>h", -- hide secondary view
      },
      secondary = {
        jump = "<CR>", -- jump to code location
        quit = "<Esc>", -- close main and secondary veiw
        hide_main = "<leader>h", -- hide main view
        enter = "<leader>l", -- enter into main view
      },
    },
  },
}
