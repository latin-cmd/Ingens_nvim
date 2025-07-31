-- ========================================
-- Markdown 和文档插件配置
-- ========================================

return {
  -- Markdown 预览
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      -- Windows 兼容的构建方法
      if vim.fn.has("win32") == 1 then
        vim.fn.system("cd app && npm install")
      else
        vim.fn["mkdp#util#install"]()
      end
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      -- 确保插件正确初始化
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ""
      vim.g.mkdp_browser = ""
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc = {},
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_port = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_theme = "dark"
    end,
  },

  -- Glow - 终端 Markdown 预览
  {
    "ellisonleao/glow.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>mg", "<cmd>Glow<cr>", desc = "Glow Preview" },
    },
    config = function()
      require("glow").setup({
        style = "dark",
        width = 120,
        height = 100,
        width_ratio = 0.8,
        height_ratio = 0.8,
      })
    end,
  },

  -- Markdown 表格格式化
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown" },
    keys = {
      { "<leader>tm", "<cmd>TableModeToggle<cr>", desc = "Toggle Table Mode" },
    },
    config = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"
    end,
  },

  -- LaTeX 支持
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_complete_close_braces = 1
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_indent_enabled = 1
      vim.g.vimtex_matchparen_enabled = 1
      vim.g.vimtex_motion_enabled = 1
      vim.g.vimtex_text_obj_enabled = 1
      vim.g.vimtex_toc_enabled = 1
    end,
  },

  -- 代码格式化
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local null_ls = require("null-ls")
      
      -- 创建 augroup
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      -- 检查工具是否可用的辅助函数
      local function is_executable(name)
        return vim.fn.executable(name) == 1
      end

      -- 安全加载 source 的函数
      local function safe_load_source(source_func, source_name)
        local success, source = pcall(source_func)
        if success and source then
          return source
        else
          vim.notify("Failed to load " .. source_name .. " source", vim.log.levels.WARN)
          return nil
        end
      end

      -- 动态构建 sources 列表
      local sources = {}

      -- Lua (仅格式化，诊断由 lua_ls LSP 提供)
      if is_executable("stylua") then
        local stylua_source = safe_load_source(function() 
          return null_ls.builtins.formatting.stylua 
        end, "stylua")
        if stylua_source then
          table.insert(sources, stylua_source)
        end
      end

      -- JavaScript/TypeScript
      if is_executable("prettier") then
        local prettier_source = safe_load_source(function() 
          return null_ls.builtins.formatting.prettier.with({
            extra_filetypes = { "toml" },
          })
        end, "prettier")
        if prettier_source then
          table.insert(sources, prettier_source)
        end
      end
      
      if is_executable("eslint") or is_executable("eslint_d") then
        local eslint_source = safe_load_source(function() 
          return null_ls.builtins.diagnostics.eslint
        end, "eslint")
        if eslint_source then
          table.insert(sources, eslint_source)
        end
      end

      -- Python
      if is_executable("black") then
        local black_source = safe_load_source(function() 
          return null_ls.builtins.formatting.black
        end, "black")
        if black_source then
          table.insert(sources, black_source)
        end
      end
      
      if is_executable("isort") then
        local isort_source = safe_load_source(function() 
          return null_ls.builtins.formatting.isort
        end, "isort")
        if isort_source then
          table.insert(sources, isort_source)
        end
      end

      -- Shell (跳过有问题的 shellcheck 诊断，只保留格式化)
      if is_executable("shfmt") then
        local shfmt_source = safe_load_source(function() 
          return null_ls.builtins.formatting.shfmt
        end, "shfmt")
        if shfmt_source then
          table.insert(sources, shfmt_source)
        end
      end

      -- Markdown
      if is_executable("markdownlint") then
        local markdownlint_source = safe_load_source(function() 
          return null_ls.builtins.diagnostics.markdownlint
        end, "markdownlint")
        if markdownlint_source then
          table.insert(sources, markdownlint_source)
        end
      end

      -- YAML
      if is_executable("yamllint") then
        local yamllint_source = safe_load_source(function() 
          return null_ls.builtins.diagnostics.yamllint
        end, "yamllint")
        if yamllint_source then
          table.insert(sources, yamllint_source)
        end
      end

      -- Go
      if is_executable("gofmt") then
        local gofmt_source = safe_load_source(function() 
          return null_ls.builtins.formatting.gofmt
        end, "gofmt")
        if gofmt_source then
          table.insert(sources, gofmt_source)
        end
      end
      
      if is_executable("goimports") then
        local goimports_source = safe_load_source(function() 
          return null_ls.builtins.formatting.goimports
        end, "goimports")
        if goimports_source then
          table.insert(sources, goimports_source)
        end
      end

      -- C/C++
      if is_executable("clang-format") then
        local clang_format_source = safe_load_source(function() 
          return null_ls.builtins.formatting.clang_format
        end, "clang-format")
        if clang_format_source then
          table.insert(sources, clang_format_source)
        end
      end

      -- 始终添加拼写检查（不需要外部工具）
      local spell_source = safe_load_source(function() 
        return null_ls.builtins.completion.spell
      end, "spell")
      if spell_source then
        table.insert(sources, spell_source)
      end

      null_ls.setup({
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      })

      -- 显示加载的工具数量
      vim.notify("Loaded " .. #sources .. " formatting/diagnostic tools", vim.log.levels.INFO)
    end,
  },

  -- 使用 mason-tool-installer 替代 mason-null-ls
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Lua (使用 lua_ls LSP 而不是 luacheck)
          "stylua",       -- Lua formatter

          -- JavaScript/TypeScript
          "prettier",     -- JS/TS/HTML/CSS formatter
          "eslint_d",     -- JS/TS linter

          -- Python
          "black",        -- Python formatter
          "isort",        -- Python import sorter
          "flake8",       -- Python linter

          -- Shell
          "shfmt",        -- Shell formatter
          "shellcheck",   -- Shell linter

          -- Markdown
          "markdownlint", -- Markdown linter

          -- YAML
          "yamllint",     -- YAML linter

          -- Go
          "gofmt",        -- Go formatter
          "goimports",    -- Go import formatter

          -- C/C++
          "clang-format", -- C/C++ formatter (注意使用连字符)
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000, -- 3 second delay
      })
    end,
  },

  -- 代码注释增强
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      { "<leader>nf", "<cmd>Neogen func<cr>", desc = "Generate function annotation" },
      { "<leader>nc", "<cmd>Neogen class<cr>", desc = "Generate class annotation" },
      { "<leader>nt", "<cmd>Neogen type<cr>", desc = "Generate type annotation" },
      { "<leader>nF", "<cmd>Neogen file<cr>", desc = "Generate file annotation" },
    },
    config = function()
      require("neogen").setup({
        enabled = true,
        input_after_comment = true,
        languages = {
          lua = {
            template = {
              annotation_convention = "ldoc",
            },
          },
          python = {
            template = {
              annotation_convention = "google_docstrings",
            },
          },
          rust = {
            template = {
              annotation_convention = "rustdoc",
            },
          },
          javascript = {
            template = {
              annotation_convention = "jsdoc",
            },
          },
          typescript = {
            template = {
              annotation_convention = "tsdoc",
            },
          },
          java = {
            template = {
              annotation_convention = "javadoc",
            },
          },
        },
      })
    end,
  },

  -- TODO 注释高亮
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup({
        signs = true,
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
          TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
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
          pattern = [[.*<(KEYWORDS)\s*:]],
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
          pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        },
      })

      -- 键盘映射
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<cr>", { desc = "Todo (Trouble)" })
      vim.keymap.set("n", "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme (Trouble)" })
      vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
      vim.keymap.set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", { desc = "Todo/Fix/Fixme" })
    end,
  },
} 