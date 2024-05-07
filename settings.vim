"remap arrows in wildmenumode
cnoremap <expr> <Right> wildmenumode() ? "\<Down>" : "\<Right>"
cnoremap <expr> <Down> wildmenumode() ? "\<Right>" : "\<Down>"
cnoremap <expr> <Left> wildmenumode() ? "\<Up>" : "\<Left>"
cnoremap <expr> <Up> wildmenumode() ? "\<Left>" : "\<Up>"

"folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=9999

set ignorecase
set smartcase

augroup HandleBuffEnter
  autocmd!
  autocmd BufEnter * lua require('custom.utils').BufEnter()
  autocmd BufLeave * lua require('custom.utils').BufLeave()
augroup end

augroup AutoSaveCursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

set colorcolumn=80
set noswapfile

