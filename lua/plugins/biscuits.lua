-- on hovering on end of code block (like end of a function) displays the block's header (like fun name + args)
return {
  "code-biscuits/nvim-biscuits",
  event = "BufReadPost",
  opts = {
    show_on_start = false,
    cursor_line_only = true,
    default_config = {
      min_distance = 10,
      max_length = 50,
      prefix_string = " 󰆘 ",
      prefix_highlight = "Comment",
      enable_linehl = true,
    },
    language_config = {
      vimdoc = {
        disabled = true,
      },
    },
  },
}
