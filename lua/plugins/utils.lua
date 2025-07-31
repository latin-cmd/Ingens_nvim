-- ========================================
-- 实用工具插件配置
-- ========================================

return {
  -- 项目管理
  {
    "ahmedkhalf/project.nvim",
    name = "project_nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("project_nvim").setup({
        -- 检测方法
        detection_methods = { "lsp", "pattern" },
        
        -- 项目标识文件/目录
        patterns = { 
          ".git", "_darcs", ".hg", ".bzr", ".svn", 
          "Makefile", "package.json", "setup.py", 
          "pyproject.toml", "requirements.txt",
          "Cargo.toml", "go.mod", "*.sln", "*.csproj",
          ".nvim.lua", ".nvimrc", ".exrc"
        },
        
        -- 忽略的 LSP 服务器
        ignore_lsp = {},
        
        -- 排除目录
        exclude_dirs = {},
        
        -- 显示隐藏文件
        show_hidden = false,
        
        -- 静默改变目录
        silent_chdir = true,
        
        -- 范围改变目录
        scope_chdir = 'global',
        
        -- 数据路径
        datapath = vim.fn.stdpath("data"),
      })
      
      -- 延迟加载 telescope 扩展，确保 telescope 已完全初始化
      vim.schedule(function()
        local success, telescope = pcall(require, 'telescope')
        if success then
          pcall(telescope.load_extension, 'projects')
        else
          vim.notify("Failed to load telescope for projects extension", vim.log.levels.WARN)
        end
      end)
    end,
  },
  -- 多光标编辑
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Multi cursor" },
      { "<C-Down>", mode = { "n", "x" }, desc = "Multi cursor down" },
      { "<C-Up>", mode = { "n", "x" }, desc = "Multi cursor up" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select Cursor Down"] = "<C-Down>",
        ["Select Cursor Up"] = "<C-Up>",
      }
    end,
  },

  -- 快速跳转
  {
    "phaazon/hop.nvim",
    branch = "v2",
    keys = {
      { "<leader>hw", "<cmd>HopWord<cr>", desc = "Hop to word" },
      { "<leader>hl", "<cmd>HopLine<cr>", desc = "Hop to line" },
      { "<leader>hc", "<cmd>HopChar1<cr>", desc = "Hop to char" },
      { "<leader>hp", "<cmd>HopPattern<cr>", desc = "Hop to pattern" },
    },
    config = function()
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran",
        jump_on_sole_occurrence = true,
        case_insensitive = true,
      })
    end,
  },

  -- 环绕字符操作
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        },
      })
    end,
  },

  -- 快速注释
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "Comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  -- 代码大纲
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
    },
    config = function()
      require("symbols-outline").setup({
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        relative_width = true,
        width = 25,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = 'Pmenu',
        autofold_depth = nil,
        auto_unfold_hover = true,
        fold_markers = { '', '' },
        wrap = false,
        keymaps = {
          close = {"<Esc>", "q"},
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          toggle_preview = "K",
          rename_symbol = "r",
          code_actions = "a",
          fold = "h",
          unfold = "l",
          fold_all = "W",
          unfold_all = "E",
          fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
          File = { icon = "", hl = "@text.uri" },
          Module = { icon = "", hl = "@namespace" },
          Namespace = { icon = "", hl = "@namespace" },
          Package = { icon = "", hl = "@namespace" },
          Class = { icon = "𝓒", hl = "@type" },
          Method = { icon = "ƒ", hl = "@method" },
          Property = { icon = "", hl = "@method" },
          Field = { icon = "", hl = "@field" },
          Constructor = { icon = "", hl = "@constructor" },
          Enum = { icon = "ℰ", hl = "@type" },
          Interface = { icon = "ﰮ", hl = "@type" },
          Function = { icon = "", hl = "@function" },
          Variable = { icon = "", hl = "@constant" },
          Constant = { icon = "", hl = "@constant" },
          String = { icon = "𝓐", hl = "@string" },
          Number = { icon = "#", hl = "@number" },
          Boolean = { icon = "⊨", hl = "@boolean" },
          Array = { icon = "", hl = "@constant" },
          Object = { icon = "⦿", hl = "@type" },
          Key = { icon = "🔐", hl = "@type" },
          Null = { icon = "NULL", hl = "@type" },
          EnumMember = { icon = "", hl = "@field" },
          Struct = { icon = "𝓢", hl = "@type" },
          Event = { icon = "🗲", hl = "@type" },
          Operator = { icon = "+", hl = "@operator" },
          TypeParameter = { icon = "𝙏", hl = "@parameter" },
          Component = { icon = "", hl = "@function" },
          Fragment = { icon = "", hl = "@constant" },
        },
      })
    end,
  },

  -- 代码折叠增强
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end
      })
    end,
  },

  -- 会话管理
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
        pre_save = nil,
      })
    end,
  },

  -- 问题诊断面板
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List" },
      { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
    },
    config = function()
      require("trouble").setup({
        position = "bottom",
        height = 10,
        width = 50,
        icons = true,
        mode = "workspace_diagnostics",
        fold_open = "",
        fold_closed = "",
        group = true,
        padding = true,
        action_keys = {
          close = "q",
          cancel = "<esc>",
          refresh = "r",
          jump = {"<cr>", "<tab>"},
          open_split = { "<c-x>" },
          open_vsplit = { "<c-v>" },
          open_tab = { "<c-t>" },
          jump_close = {"o"},
          toggle_mode = "m",
          toggle_preview = "P",
          hover = "K",
          preview = "p",
          close_folds = {"zM", "zm"},
          open_folds = {"zR", "zr"},
          toggle_fold = {"zA", "za"},
          previous = "k",
          next = "j"
        },
        indent_lines = true,
        auto_open = false,
        auto_close = false,
        auto_preview = true,
        auto_fold = false,
        auto_jump = {"lsp_definitions"},
        signs = {
          error = "E",
          warning = "W",
          hint = "H",
          information = "I",
          other = "O"
        },
        use_diagnostic_signs = false
      })
    end,
  },

  -- 浮动终端文件管理器
  {
    "voldikss/vim-floaterm",
    keys = {
      { "<leader>ft", "<cmd>FloatermNew<cr>", desc = "New floaterm" },
      { "<leader>fr", "<cmd>FloatermNew ranger<cr>", desc = "Ranger" },
    },
    config = function()
      vim.g.floaterm_keymap_toggle = '<F12>'
      vim.g.floaterm_keymap_new = '<F9>'
      vim.g.floaterm_keymap_prev = '<F10>'
      vim.g.floaterm_keymap_next = '<F11>'
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_position = 'center'
      vim.g.floaterm_borderchars = '─│─│╭╮╯╰'
    end,
  },

  -- 代码执行器 (替代 sniprun，无需编译)
  {
    "CRAG666/code_runner.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>rs", "<cmd>RunCode<cr>", desc = "Run code", mode = { "n", "v" } },
      { "<leader>rf", "<cmd>RunFile<cr>", desc = "Run file" },
      { "<leader>rc", "<cmd>RunClose<cr>", desc = "Close runner" },
      { "<leader>rr", "<cmd>CRFiletype<cr>", desc = "Choose runner" },
    },
    config = function()
      require("code_runner").setup({
        filetype = {
          java = {
            "cd $dir &&",
            "javac $fileName &&",
            "java $fileNameWithoutExt"
          },
          python = "python3 -u",
          typescript = "deno run",
          rust = {
            "cd $dir &&",
            "rustc $fileName &&",
            "$dir/$fileNameWithoutExt"
          },
          c = function(...)
            local c_base = {
              "cd $dir &&",
              "gcc $fileName -o",
              "/tmp/$fileNameWithoutExt",
            }
            local c_exec = {
              "&& /tmp/$fileNameWithoutExt &&",
              "rm /tmp/$fileNameWithoutExt",
            }
            vim.list_extend(c_base, c_exec)
            return table.concat(c_base, " ")
          end,
          cpp = {
            "cd $dir &&",
            "g++ $fileName",
            "-o /tmp/$fileNameWithoutExt &&",
            "/tmp/$fileNameWithoutExt"
          },
          javascript = "node",
          sh = "bash",
          lua = "lua",
        },
        mode = "term",
        focus = true,
        startinsert = false,
        term = {
          position = "bot",
          size = 8,
          float = {
            border = "single",
          },
        },
      })
    end,
  },
} 