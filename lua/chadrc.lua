---@type ChadrcConfig
local M = {}

local tabufline_modules = require("custom.tabufline_modules")

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl = highlights
	hl_add = {
		TbHLSuccess = {
			fg = "black",
			bg = "green",
		},
		TbHLWarning = {
			fg = "black",
			bg = "yellow",
		},
		TbHLError = {
			fg = "#ffffff",
			bg = "red",
		},
	},
	hl_override = {
		DiffText = {
			--fg = "black",
			bg = "grey",
		},
    TbTabOn = {
			bg = "#ffffff",
    },
    TbTabOff = {
			bg = "grey",
    },
		DiffAdd = {
			bg = "grey",
		},
		Visual = {
			bg = "grey",
			--test
		},
		Comment = {
			fg = "#777777",
		},
    Normal = {
      bg = "#0a0a0a",
    }
	},
  --changed_themes = {},
  theme_toggle = { "onedark", "one_light" },
  theme = "onedark",
  transparency = true,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
  },

  telescope = { style = "borderless" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "default", -- default/vscode/vscode_colored/minimal
    separator_style = "default",
    order = {"git", "%=", "lsp", "lsp_msg", "diagnostics", "cursor_position"},
    modules = {
      cursor_position = function()
        local current_line = vim.fn.line(".")
        local total_line = vim.fn.line("$")
        local percentage_position = math.modf((current_line / total_line) * 100) .. tostring("%%")
        percentage_position = string.format("%4s", percentage_position)

        percentage_position = (current_line == 1 and "Top") or percentage_position
        percentage_position = (current_line == total_line and "Bot") or percentage_position

        return "%#StText# %l:%c (" .. percentage_position .. ") "
      end,
    }
  },

  tabufline = {
    enabled = true,
    lazyload = false,
    --order = { "treeOffset", "custom_buffers", "custom_tabs" },
    order = { "treeOffset", "custom_buffers", "custom_tabs" },
    --modules = nil
    modules = {custom_buffers = tabufline_modules.buffers, custom_tabs = tabufline_modules.tabs},
  },

  lsp = { signature = true },

  term = {
    hl = "Normal:term,WinSeparator:WinSeparator",
    sizes = { sp = 0.3, vsp = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },
}

return M
