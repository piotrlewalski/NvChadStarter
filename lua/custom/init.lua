--addresing NvimTree recomnendation https://github.com/nvim-tree/nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function RunAfterConfig()
end

vim.cmd("autocmd VimEnter * lua RunAfterConfig()")
vim.cmd("set mouse=")

--auto close terminal window when the process exits
vim.cmd([[autocmd TermClose * lua vim.api.nvim_input('<CR>')]])
vim.cmd([[autocmd TermOpen * resize 10]])
