require("lazy").setup({
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  -- "ellisonleao/gruvbox.nvim",
  "nvim-lualine/lualine.nvim",
  "vim-test/vim-test",
  "kassio/neoterm",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "airblade/vim-gitgutter",
  "mileszs/ack.vim",
  "github/copilot.vim",
  {
    "nvim-telescope/telescope.nvim", tag = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' 
  },
  {
    "kylechui/nvim-surround",
    version = "*", 
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },
 {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "eex", "heex", "javascript", "html", "groovy", "python", "sql", "typescript" },
      sync_install = false,
      highlight = { 
        enable = true,
        -- Añadir protección contra archivos problemáticos
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
          
          -- Verificar que el buffer y la ventana sean válidos
          if not vim.api.nvim_buf_is_valid(buf) then
            return true
          end
          
          local win = vim.fn.bufwinid(buf)
          if win == -1 or not vim.api.nvim_win_is_valid(win) then
            return true
          end
          
          return false
        end,
        -- Añadir callback de error personalizado
        additional_vim_regex_highlighting = false,
      },
      indent = { 
        enable = true,
        disable = { "python" } -- Python tiene mejor indentación nativa
      },
      -- Añadir configuración de parsing incremental más conservadora
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    })
    
    -- Manejar errores específicos de Tree-sitter para Elixir
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"elixir", "eex", "heex"},
      callback = function(args)
        local buf = args.buf
        -- Verificar que el buffer sea válido antes de habilitar highlighting
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 and vim.api.nvim_win_is_valid(win) then
              pcall(function()
                vim.treesitter.start(buf)
              end)
            end
          end
        end)
      end,
    })
    
    -- Manejo global de errores de Tree-sitter
    local original_notify = vim.notify
    vim.notify = function(msg, level, opts)
      -- Suprimir errores específicos de window id inválido
      if type(msg) == "string" and msg:match("Invalid window id") then
        return
      end
      original_notify(msg, level, opts)
    end
  end
},
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   build = ":TSUpdate",
  --   config = function () 
  --     local configs = require("nvim-treesitter.configs")

  --     configs.setup({
  --       ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "eex", "heex", "javascript", "html", "groovy", "python", "sql", "typescript" },
  --       sync_install = false,
  --       highlight = { enable = true },
  --       indent = { enable = true },  
  --     })
  --   end
  -- },
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			lspconfig.elixirls.setup({
				cmd = { "elixir-ls" },
				capabilities = capabilities,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- install different completion source
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				-- add different completion source
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				-- using default mapping preset
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				snippet = {
					-- you must specify a snippet engine
					expand = function(args)
						-- using neovim v0.10 native snippet feature
						-- you can also use other snippet engines
						vim.snippet.expand(args.body)
					end,
				},
			})
		end,
	},
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "main",
  --   cmd = "CopilotChat",
  --   opts = function()
  --     local user = vim.env.USER or "User"
  --     user = user:sub(1, 1):upper() .. user:sub(2)
  --     return {
  --       model = "gpt-4-0125-preview",
  --       auto_insert_mode = true,
  --       show_help = true,
  --       question_header = "  " .. user .. " ",
  --       answer_header = "  Copilot ",
  --       window = {
  --         width = 0.4,
  --       },
  --       selection = function(source)
  --         local select = require("CopilotChat.select")
  --         return select.visual(source) or select.buffer(source)
  --       end,
  --     }
  --   end,
  --   keys = {
  --     { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
  --     { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
  --     {
  --       "<leader>aa",
  --       function()
  --         return require("CopilotChat").toggle()
  --       end,
  --       desc = "Toggle (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ax",
  --       function()
  --         return require("CopilotChat").reset()
  --       end,
  --       desc = "Clear (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input)
  --         end
  --       end,
  --       desc = "Quick Chat (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --   },
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")

  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-chat",
  --       callback = function()
  --         vim.opt_local.relativenumber = false
  --         vim.opt_local.number = false
  --       end,
  --     })

  --     chat.setup(opts)
  --   end,
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
  --     { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  --   },
  --   build = "make tiktoken", -- Only on MacOS or Linux
  --   opts = {
  --     -- See Configuration section for options
  --   },
  --   keys = {
  --     {
  --       "<leader>ccq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat",
  --     }
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
{
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
    config = function(_, opts)
        require("tokyodark").setup(opts) -- calling setup is optional
        vim.cmd [[colorscheme tokyodark]]
    end
},
-- ,{
-- "karb94/neoscroll.nvim",
-- opts = {},
-- }
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, 
  opts = {
    provider = "claude",
    auto_suggestions_provider = "claude",
    providers = {
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o", 
        extra_request_body = {
          timeout = 30000, 
          temperature = 0.75,
          max_completion_tokens = 8192,
          --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
        },
      },
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-3-5-sonnet-20241022",
      extra_request_body = {
        temperature = 0,
        max_tokens = 4096,
      },
    },
  },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
})

