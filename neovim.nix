{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      " Basic settings
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set wrap
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch
      set termguicolors
      set scrolloff=8
      set signcolumn=yes
      set updatetime=50

      " Leader key
      let mapleader = " "

      " Basic keymaps
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>h :nohlsearch<CR>

      " Window navigation
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      " Buffer navigation
      nnoremap <leader>bn :bnext<CR>
      nnoremap <leader>bp :bprevious<CR>
      nnoremap <leader>bd :bdelete<CR>
    '';

    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      vim-sensible

      # File explorer
      nvim-tree-lua

      # Fuzzy finder
      telescope-nvim
      plenary-nvim

      # Syntax highlighting
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context

      # Git integration
      # gitsigns-nvim

      # UI plugins
      which-key-nvim
      trouble-nvim
      todo-comments-nvim
      bufferline-nvim
      lualine-nvim
      mini-nvim # Includes mini.icons, mini.indentscope, mini.cursorword, mini.hipatterns
      snacks-nvim

      # Editing plugins
      vim-surround
      yanky-nvim

      # Color scheme
      dracula-nvim

      # Commenting
      comment-nvim
      ts-comments-nvim

      # Formatting
      conform-nvim

      # LSP
      nvim-lspconfig

      # Autocompletion
      blink-cmp
      luasnip
      friendly-snippets
    ];

    extraLuaConfig = ''
      -- Add local plugin to runtime path for development
      -- vim.opt.runtimepath:prepend('/home/obayemi/dev/jjsigns.nvim')
      vim.opt.runtimepath:prepend('/home/obayemi/dev/gitsigns.nvim')

      -- Color scheme
      require('dracula').setup({
        transparent_bg = true,
        show_end_of_buffer = true,
        italic_comment = true,
      })
      vim.cmd[[colorscheme dracula]]

      -- Nvim-tree setup
      require('nvim-tree').setup({
        view = {
          width = 30,
        },
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
            },
          },
        },
      })

      -- Telescope setup
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })

      -- Treesitter setup
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })

      -- Gitsigns setup
      -- require('gitsigns').setup()

      require('gitsigns').setup {
        vcs = 'jj',  -- or 'jj' to force Jujutsu
        debug_mode = true,
        -- other options...
      }

      -- Lualine setup
      require('lualine').setup({
        options = {
          theme = 'dracula',
        },
      })

      -- Comment setup
      require('Comment').setup({
        padding = true,
        sticky = true,
        ignore = '^$',
        mappings = {
          basic = false,
          extra = false,
        },
      })
      require('ts-comments').setup()

      -- Custom Ctrl+C commenting keymaps
      local api = require('Comment.api')
      
      -- Ctrl+C to toggle comment for current line in normal mode
      vim.keymap.set('n', '<C-c>', function()
        api.toggle.linewise.current()
      end, { desc = "Toggle comment line" })
      
      -- Ctrl+C to toggle comment for selection in visual mode
      vim.keymap.set('v', '<C-c>', function()
        local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
        vim.api.nvim_feedkeys(esc, 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end, { desc = "Toggle comment selection" })

      -- LSP setup using vim.lsp.config (Neovim 0.11+)
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Use default configs for explicitly supported LSPs
      -- Only override capabilities for completion support
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Override lua_ls to add vim global
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'},
            },
          },
        },
      })

      vim.lsp.config('ruff', {
        capabilities = capabilities,
        init_options = {
          settings = {
            organizeImports = true,
            fixAll = true,
            lint = {
              enable = true,
            },
            format = {
              enable = true,
            },
          }
        },
        settings = {
          args = { "--select", "ALL", "--extend-select", "I" },
        }
      })

      -- Configure basedpyright for completion only
      vim.lsp.config('basedpyright', {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            -- Disable diagnostics (let ruff handle them)
            disableLanguageServices = false,
            disableOrganizeImports = true,
            
            analysis = {
              ignorePatterns = { "*.pyi" },

              -- Disable most type checking diagnostics
              typeCheckingMode = "recommended",
              diagnosticMode = "workspace",
              
              -- Disable specific diagnostic categories
              diagnosticSeverityOverrides = {
                reportUnusedImport = "none",
                reportUnusedClass = "none",
                reportUnusedFunction = "none",
                reportUnusedVariable = "none",
                reportDuplicateImport = "none",
                reportWildcardImportFromLibrary = "none",
                reportOptionalSubscript = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalCall = "none",
                reportOptionalIterable = "none",
                reportOptionalContextManager = "none",
                reportOptionalOperand = "none",
                reportGeneralTypeIssues = "none",
                reportMissingImports = "none",
                reportMissingTypeStubs = "none",
              },
              
              -- Focus on completion and hover info
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      })

      -- Enable LSP servers (uses default configs)
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('nil_ls')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('ruff')
      vim.lsp.enable('basedpyright')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('clangd')
      -- vim.lsp.enable('gopls')
      vim.lsp.enable('hls')
      vim.lsp.set_log_level('debug')

      -- Blink completion setup
      require('luasnip.loaders.from_vscode').lazy_load()

      require('blink.cmp').setup({
        keymap = {
          preset = 'default',
          ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-e>'] = { 'hide' },
          ['<C-y>'] = { 'select_and_accept' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
          ['<CR>'] = { 'select_and_accept', 'fallback' },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono'
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          -- cmdline = {},
        },
        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            draw = {
              treesitter = { 'lsp' },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },
        },
        signature = {
          enabled = true
        }
      })

      -- LSP keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>f', function()
            require("conform").format({ lsp_format = "fallback", async = true })
          end, opts)
        end,
      })

      -- Global LSP diagnostic navigation
      vim.keymap.set('n', '<C-j>', vim.diagnostic.goto_next, {})
      vim.keymap.set('n', '<C-k>', vim.diagnostic.goto_prev, {})

      -- Key mappings
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader><space>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>/', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})

      -- Which-key setup
      require('which-key').setup({
        preset = "modern",
      })

      -- Trouble setup
      require('trouble').setup({
        icons = false,
        fold_open = "v",
        fold_closed = ">",
        indent_lines = false,
        signs = {
          error = "error",
          warning = "warn",
          hint = "hint",
          information = "info"
        },
        use_diagnostic_signs = false
      })

      vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
      vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
      vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
      vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
      vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
      vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

      -- Todo-comments setup
      require('todo-comments').setup({
        signs = false,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF006E" }
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]]
        },
      })

      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
      vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })
      vim.keymap.set("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
      vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
      vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })

      -- Bufferline setup
      require('bufferline').setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = false
        },
        highlights = {
          separator = {
            fg = '#434C5E',
            bg = '#2E3440',
          },
          separator_selected = {
            fg = '#434C5E',
          },
          background = {
            fg = '#81A1C1',
            bg = '#2E3440'
          },
          buffer_selected = {
            fg = '#ECEFF4',
            bold = true,
          },
          fill = {
            bg = '#2E3440'
          }
        },
      })

      vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', {})
      vim.keymap.set('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', {})
      vim.keymap.set('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', {})
      vim.keymap.set('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', {})
      vim.keymap.set('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', {})
      vim.keymap.set('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>', {})
      vim.keymap.set('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>', {})
      vim.keymap.set('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>', {})
      vim.keymap.set('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>', {})
      vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', {})
      vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', {})

      -- Mini.nvim plugins setup
      require('mini.icons').setup()
      require('mini.indentscope').setup({
        symbol = "│",
        options = { try_as_border = true },
      })
      require('mini.cursorword').setup()
      require('mini.hipatterns').setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
          
          -- Highlight hex color strings
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })

      -- Snacks.nvim setup
      require('snacks').setup({
        bigfile = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
          notification = {
            wo = { wrap = true }
          }
        }
      })

      -- Treesitter context setup
      require('treesitter-context').setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        patterns = {
          default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'interface',
            'struct',
            'enum',
          },
        },
      })

      -- Yanky setup
      require('yanky').setup({
        ring = {
          history_length = 100,
          storage = "shada",
          sync_with_numbered_registers = true,
          cancel_event = "update",
        },
        picker = {
          select = {
            action = nil,
          },
          telescope = {
            use_default_mappings = true,
          },
        },
        system_clipboard = {
          sync_with_ring = true,
        },
        highlight = {
          on_put = true,
          on_yank = true,
          timer = 500,
        },
        preserve_cursor_position = {
          enabled = true,
        },
      })

      vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
      vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
      vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")
      vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
      vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
      vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
      vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")  
      vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
      vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

      -- Conform.nvim setup for formatting
      require('conform').setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format", "ruff_organize_imports" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          nix = { "nixfmt" },
          rust = { "rustfmt" },
          go = { "goimports", "gofmt" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          haskell = { "fourmolu" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        format_after_save = {
          lsp_format = "fallback",
        },
        log_level = vim.log.levels.ERROR,
        notify_on_error = false,
      })

      -- Format keymap
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        require("conform").format({
          lsp_format = "fallback",
          async = false,
          timeout_ms = 500,
        })
      end, { desc = "Format file or range (in visual mode)" })
    '';
  };
}
