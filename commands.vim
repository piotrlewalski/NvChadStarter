command! Test luafile "$HOME/projects/config/test.lua"

"AutoReload command
command! AutoReload lua require("custom.utils").StartAutoReload()

"Diagnostics
"command! Dnext LspUI diagnostic next
"command! Dprev LspUI diagnostic prev
command! Definition LspUI definition
command! TypeDefinition LspUI type_definition
command! Declaration LspUI declaration
command! Reference LspUI reference
command! Implementation LspUI implementation

"Breadcrumbs
"navigate to the top of the current block if no arg given or to the provided block
command! -nargs=? B lua require("barbecue.ui").navigate("<args>" and -1)
"breadcrumb up - navigete to the parent block
command! Bup lua require("barbecue.ui").navigate(-2)
command! Btoggle Barbecue toggle

"Git
command! GitRestore !git restore %
command! GitBlame lua require"gitsigns".toggle_current_line_blame()
command! GitDiff lua require"gitsigns".diffthis()
command! -nargs=? -complete=file GitStatus lua require"custom.utils".GitStatus(<f-args>)
command! GitAdd silent !git add %
command! -nargs=1 GitCommit :!git commit -m <args>
command! GitCommitLog Telescope git_commits
command! GitBufferCommitLog Telescope git_bcommits
"command! GitRangeCommitLog Telescope git_bcommits_range "TODO looks that this doesn't work yet
command! GitBranches Telescope git_branches
command! GitStashList Telescope git_stash

command! -nargs=? Terminal lua require("custom.utils").CreateTerminal(<f-args>)

"Query commands
command! QLiveGrep Telescope live_grep
command! QCommands Telescope commands
command! QOptions Telescope vim_options
command! QKeymaps Telescope keymaps
command! QBufferFuzzyFind Telescope current_buffer_fuzzy_find
command! QTreeSitter Telescope treesitter
command! QTelescope Telescope builtin
command! QDocumentSymbols Telescope lsp_document_symbols
command! QWorkspaceSymbols Telescope lsp_dynamic_workspace_symbols
command! QDiagnostics Telescope diagnostics bufnr=0
command! QDiagnosticsAllOpened Telescope diagnostics
command! QImplementations Telescope lsp_implementations
command! QGitLiveGrep lua require('custom.utils').LiveGrepSkipGitSubmodules()

"explorer
command! EFindFile NvimTreeFindFile
command! ERefresh NvimTreeRefresh

"Support for ANSI codes in files
"command! AnsiColors lua require("custom.utils").baleia().once(vim.api.nvim_get_current_buf())

"Closing buffers
command! CloseAll lua require("nvchad.tabufline").closeAllBufs()
command! CloseOther lua require("nvchad.tabufline").closeOtherBufs()
command! CloseLeft lua require("nvchad.tabufline").closeBufs_at_direction("left")
command! CloseRight lua require("nvchad.tabufline").closeBufs_at_direction("right")

"Theme
command! ThemeToggle lua require("base46").toggle_theme()
