require "nvchad.mappings"
local utils = require("custom.utils")
local buffer_picker = require("custom.buffer_picker").buffer_picker

local function map(mode, mapping, action, desc)
  vim.keymap.set(mode, mapping, action, { desc = desc, noremap=true })
end

local function foldLevelSetter(level)
  return function()
    return utils.SetFoldLevel(level)
  end
end

--FIXME
--map("n", "[d", ":LspUI diagnostic prev<CR>", { desc = "Diagnostics prev" })
--map("n", "]d", ":LspUI diagnostic next<CR>", { desc = "Diagnostics next" })
map("n", ",,b", buffer_picker, "Tree focus")
map("n", "d", '"_d')  -- deleting text doesn't put it in the clipboard
map("n", "D", '"_D')  -- deleting text doesn't put it in the clipboard
map("n", "x", '"_x')  -- deleting a character doesn't put it in the clipboard
map("n", "X", "v$hx") -- X cuts text from current position untill the end of the line
map("n", "<M-Tab>", "<C-w>w")
map("n", "<M-S-Tab>", "<C-w>W")
map("n", "<S-Right>", function() require("nvchad.tabufline").move_buf(1) end, "Move current tab to right")
map("n", "<S-Left>", function() require("nvchad.tabufline").move_buf(-1) end, "Move current tab to right")
map("n", ",,o", utils.SwitchToFileWindow, "Open file")
map("n", ",,m", ":LspUI hover<CR>", "Hover message")
map("n", "gr", ":Telescope lsp_references<CR>", "References")
map("n", "gd", ":Telescope lsp_definitions<CR>", "Definitions")
--map("n", "gd", ":FzfLua lsp_definitions<CR>", "Definitions")
--map("n", "gr", ":FzfLua lsp_references<CR>", "References")
map("n", ",,w", "<C-W>w", "Next window")
map("n", ",,W", "<C-W>W", "Next window")
map("n", ",,i", ":Telescope lsp_incoming_calls<CR>", "Calls to the function")
map("n", ",,r", ":LspUI rename<CR>", "Rename")
--map("n", ",,a", ":FzfLua lsp_code_actions<CR>", "Code action")
map("n", ",,a", require("actions-preview").code_actions, "Code action")
map("n", ",,e", utils.SwitchToFileTree, "Tree focus")
map("n", ",,s", utils.SwitchToOutline, "Outline focus")
map("n", ",,h", ":NvCheatsheet<CR>", "Key Mappings")
map("n", ",,q", function() require("nvchad.tabufline").close_buffer() end, "Close buffer")
map("n", "=", function() vim.lsp.buf.format({ async = false }) end, "LSP formatting")
map("n", ",,t", utils.SwitchToTerminalWindow, "Open term if needed and switch to it")
map("n", ",,T", function() require("nvterm.terminal").send("!!") end, "Repeat last terminal command")
map("n", ",,gc", function() require("treesitter-context").go_to_context() end, "Go to context") --TODO
map("n", ",,0", foldLevelSetter(9999), "Expand all")
map("n", ",,1", foldLevelSetter(0), "Collapse all")
map("n", ",,2", foldLevelSetter(1), "Set fold level")
map("n", ",,3", foldLevelSetter(2), "Set fold level")
map("n", ",,4", foldLevelSetter(3), "Set fold level")
map("n", ",,5", foldLevelSetter(4), "Set fold level")
map("n", ",,6", foldLevelSetter(5), "Set fold level")
map("n", ",,7", foldLevelSetter(6), "Set fold level")
map("n", ",,8", foldLevelSetter(7), "Set fold level")
map("n", ",,9", foldLevelSetter(8), "Set fold level")

map("t", "<Esc><Esc>", function() utils.ExitTerminalMode() end, "Exit terminal mode")
map("t", ",,o", function() utils.SwitchToFileWindow() end, "Switch to to source file window")
map("t", ",,s", function() utils.SwitchToOutline() end, "Switch to outline window")
map("t", ",,e", function()
  utils.ExitTerminalMode(); utils.SwitchToFileTree()
end, "Switch to file tree file window")
map("t", ",,w", function() vim.cmd("wincmd w") end, "Next window")
map("t", "gt", function() vim.cmd("tabnext") end, "Next tab")
map("t", "gT", function() vim.cmd("tabprevious") end, "Next tab")
