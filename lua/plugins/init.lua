return {
  --{
  --  "NvChad/nvterm",
  --  init = function()
  --    require("core.utils").load_mappings("nvterm")
  --  end,
  --  config = function(_, opts)
  --    opts = {
  --      terminals = {
  --        list = {},
  --        type_opts = {
  --          float = {
  --            relative = "editor",
  --            row = 0.3,
  --            col = 0.25,
  --            width = 0.5,
  --            height = 0.4,
  --            border = "single",
  --          },
  --          horizontal = { location = "bot", split_ratio = 0.15 },
  --          vertical = { location = "rightbelow", split_ratio = 0.1 },
  --        },
  --      },
  --      behavior = {
  --        autoclose_on_quit = {
  --          enabled = false,
  --          confirm = true,
  --        },
  --        close_on_exit = true,
  --        auto_insert = false,
  --      },
  --    }
  --    require("nvterm.termutil")
  --    require("base46.term")
  --    require("nvterm").setup(opts)
  --  end,
  --},
  { "creativenull/efmls-configs-nvim", dependencies = { "neovim/nvim-lspconfig" }, lazy = false },
  { "folke/trouble.nvim", lazy = false },
  {
    "nvim-telescope/telescope.nvim",
    --opts = { pickers = { git_files = true } },
  },
  { --Prevents opening files in windows like vimtree, etc
    "stevearc/stickybuf.nvim",
    opts = {},
    lazy = false,
  },
  {
    "aznhe21/actions-preview.nvim",
    lazy = false,
  },
  --{
  --	"neovim/nvim-lspconfig",
  --	--dependencies = {
  --	--	{
  --	--		"jose-elias-alvarez/null-ls.nvim",
  --	--		config = function()
  --	--			require("custom.configs.null-ls")
  --	--		end,
  --	--	},
  --	--},
  --	config = function()
  --		require("plugins.configs.lspconfig")
  --		require("custom.configs.lspconfig")
  --	end,
  --},
  --{
  --	"williamboman/mason.nvim",
  --	opts = {
  --		ensure_installed = {
  --			"lua-language-server",
  --			--"typescript-language-server",
  --			"html-lsp",
  --			"prettier",
  --			"stylua",
  --		},
  --	},
  --},
  --{ --probably not required because barbecue plays a similar role
  --	"nvim-treesitter/nvim-treesitter-context",
  --	event = "BufReadPost",
  --	opts = {
  --		throttle = true,
  --		max_lines = 0,
  --		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
  --		--patterns = {
  --		--  default = {
  --		--    "class",
  --		--    "function",
  --		--    "method",
  --		--  },
  --		--},
  --	},
  --},
  --{
  --  "weilbith/nvim-code-action-menu",
  --  cmd = "CodeActionMenu",
  --  init = function()
  --    vim.g.code_action_menu_show_details = true
  --    vim.g.code_action_menu_show_diff = true
  --    vim.g.code_action_menu_show_action_kind = true
  --  end,
  --  config = function()
  --    dofile(vim.g.base46_cache .. "git")
  --  end,
  --},
  --{
  --	vim.fn.stdpath("config") .. "plugins/projects.lua",
  --	config = function()
  --		require("plugins.projects").run()
  --	end,
  --	event = "VeryLazy",
  --	dev = true,
  --},
  --{
  --  "ibhagwan/fzf-lua",
  --  dependencies = { "nvim-tree/nvim-web-devicons" },
  --  config = function()
  --    require("fzf-lua").setup({})
  --  end,
  --  lazy = false, --otherwise commands don't work before the plugin is loaded
  --},
  --{
  --  "CopilotC-Nvim/CopilotChat.nvim",
  --  branch = "canary",
  --  dependencies = {
  --    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --  },
  --  opts = {
  --    debug = false,
  --    -- See Configuration section for rest
  --  },
  --  lazy = false,
  --  -- See Commands section for default commands if you want to lazy load on them
  --},
  --{
  --  "L3MON4D3/LuaSnip",
  --  enabled = false
  --}
  --{causes issues with tabs
  --	"sunjon/shade.nvim",
  --	lazy = false,
  --	opts = {
  --		overlay_opacity = 75, -- opacity of the shading effect
  --		opacity_step = 1, -- value between 0 and 100 that determines the opacity of the active window
  --		keys = {
  --			brightness_up = "<C-Up>",
  --			brightness_down = "<C-Down>",
  --		},
  --	},
  --},
  --{ --to use ANSI colors in previewed files
  --	"m00qek/baleia.nvim",
  --	lazy = false,
  --},
}
