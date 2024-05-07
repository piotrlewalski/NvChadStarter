--addresing NvimTree recomnendation https://github.com/nvim-tree/nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function RunAfterConfig()
end

vim.cmd("autocmd VimEnter * lua RunAfterConfig()")
vim.cmd("set mouse=")

function CreateTerm(args)
  local newTerm = require("nvchad.term").new
  if args.args ~= "" then
    newTerm({ pos = "sp", size = 0.3, cmd = args.args })
  else
    newTerm({ pos = "sp", size = 0.3 })
  end
  vim.cmd("wincmd J") --make sure that the window occupies the whole bottom
end

vim.api.nvim_create_user_command("Terminal", CreateTerm,
  { nargs = "?" })

--auto close terminal window when the process exits
vim.cmd([[autocmd TermClose * lua vim.api.nvim_input('<CR>')]])
vim.cmd([[autocmd TermOpen * resize 10]])
