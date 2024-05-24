return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "typescript-language-server",
        "efm",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  --{
  "NvChad/nvterm",
  init = function()
    require("core.utils").load_mappings "nvterm"
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
    require "nvterm.termutil"
    require "base46.term"
    require("nvterm").setup(opts)
  end,
  --},
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
  { "creativenull/efmls-configs-nvim", dependencies = { "neovim/nvim-lspconfig" }, lazy = false },
  { "folke/trouble.nvim",              lazy = false },

  --Copilot
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    cmd = { "Copilot" },
    opts = {
      suggestion = { enabled = false },
      panel = { auto_refresh = true, layout = { ratio = 0.2 } },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        event = { "InsertEnter" },
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = {
      sources = {
        { name = "nvim_lsp" },
        { name = "html-css" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "copilot" },
      },
    },
    event = { "InsertEnter" },
  },
  --{
  --  "Jezda1337/nvim-html-css",
  --  dependencies = {
  --    "nvim-treesitter/nvim-treesitter",
  --    "nvim-lua/plenary.nvim",
  --  },
  --  config = function()
  --    require("html-css"):setup()
  --  end,
  --  event = { "InsertEnter" },
  --},
  {
    "nvim-telescope/telescope.nvim",
    --opts = { pickers = { git_files = true } },
  },
  {
    --lvim.builtin.nvimtree.setup.update_focused_file.enable = false
    --lvim.builtin.nvimtree.setup.update_focused_file.update_root = false --do not change root when symlink is opened
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        custom = { "^\\.git$", "^\\.github$" },
        git_ignored = false,
      },
      live_filter = {
        prefix = "F clears:",
      },
      git = {
        enable = true,
      },
      view = {
        width = 30,
      },
      renderer = {
        symlink_destination = false,
        icons = {
          show = {
            git = true,
            folder_arrow = false,
          },
        },
      },
      hijack_directories = {
        enable = true,
      },
      update_focused_file = {
        enable = false,
      },
    },
  },
  { -- on hovering on end of code block (like end of a function) displays the block's header (like fun name + args)
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
  },
  { --highligts other usages of the highlighted token
    "RRethy/vim-illuminate",
    event = { "CursorHold", "CursorHoldI" },
    dependencies = "nvim-treesitter",
    config = function()
      require("illuminate").configure {
        under_cursor = true,
        max_file_lines = nil,
        delay = 100,
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        filetypes_denylist = {
          "NvimTree",
          "Trouble",
          "Outline",
          "TelescopePrompt",
          "Empty",
          "dirvish",
          "fugitive",
          "alpha",
          "packer",
          "neogitstatus",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "aerial",
        },
      }
    end,
  },
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
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        default_direction = "left",
        placement = "window",
        width = 30,
      },
      manage_folds = true,
      on_attach = function(bufnr) end,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
  },
  { -- colorful nested brackets
    "hiphish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
  { -- Rename, hover, etc.
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
          back = "<leader>l",           -- back to secondary view
          hide_secondary = "<leader>h", -- hide secondary view
        },
        secondary = {
          jump = "<CR>",           -- jump to code location
          quit = "<Esc>",          -- close main and secondary veiw
          hide_main = "<leader>h", -- hide main view
          enter = "<leader>l",     -- enter into main view
        },
      },
    },
  },
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
  { -- Breadcrumbs
    "utilyre/barbecue.nvim",
    event = "LspAttach",
    dependencies = {
      "SmiteshP/nvim-navic",
    },
    opts = {},
  },
  { -- Git signs
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = false,
      numhl = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 10,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.cmd [[
          if exists(":GitSigns")
            delcommand GitSigns
          endif
        ]]

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        -- TODO Keymappings doubled with Git commands
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
      end,
    },
    dependencies = {
      {
        "sindrets/diffview.nvim",
        config = true,
      },
    },
  },
  { --Prevents opening files in windows like vimtree, etc
    "stevearc/stickybuf.nvim",
    opts = {},
    lazy = false,
  },
  --{
  --	vim.fn.stdpath("config") .. "plugins/projects.lua",
  --	config = function()
  --		require("plugins.projects").run()
  --	end,
  --	event = "VeryLazy",
  --	dev = true,
  --},
  {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension "frecency"
    end,
    dependencies = { "kkharji/sqlite.lua" },
    lazy = false,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup {}
    end,
    lazy = false, --otherwise commands don't work before the plugin is loaded
  },
  {
    "aznhe21/actions-preview.nvim",
    lazy = false,
  },
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
