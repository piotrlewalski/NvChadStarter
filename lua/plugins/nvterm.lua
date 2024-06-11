return {
  "NvChad/nvterm",
  init = function()
    require("core.utils").load_mappings("nvterm")
  end,
  config = function(_, opts)
    opts = {
      terminals = {
        list = {},
        type_opts = {
          float = {
            relative = "editor",
            row = 0.3,
            col = 0.25,
            width = 0.5,
            height = 0.4,
            border = "single",
          },
          horizontal = { location = "bot", split_ratio = 0.15 },
          vertical = { location = "rightbelow", split_ratio = 0.1 },
        },
      },
      behavior = {
        autoclose_on_quit = {
          enabled = false,
          confirm = true,
        },
        close_on_exit = true,
        auto_insert = false,
      },
    }
    require("nvterm.termutil")
    require("base46.term")
    require("nvterm").setup(opts)
  end,
}
