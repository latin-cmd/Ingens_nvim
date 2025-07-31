-- ========================================
-- Telescope 文件搜索和导航配置
-- ========================================

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.4",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "ahmedkhalf/project.nvim", -- 项目管理支持
    },
    cmd = "Telescope",
    keys = {
      -- 文件搜索
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find word under cursor" },
      
      -- Git 搜索
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      
      -- LSP 搜索
      { "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "LSP references" },
      { "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "LSP definitions" },
      { "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "LSP implementations" },
      { "<leader>lt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP type definitions" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      
      -- 其他搜索
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
      { "<leader>fp", "<cmd>Telescope find_files cwd=~<cr>", desc = "Find files in home" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
      { "<leader>fP", "<cmd>FindProjects<cr>", desc = "Switch Project" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          -- 外观设置
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          multi_icon = " ",
          
          -- 行为设置
          sorting_strategy = "ascending",
          selection_strategy = "reset",
          scroll_strategy = "cycle",
          layout_strategy = "horizontal",
          
          -- 布局配置
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- 文件忽略设置
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.DS_Store",
            "%.pyc",
            "__pycache__/",
            "%.o",
            "%.a",
            "%.so",
            "%.dylib",
            "%.class",
            "%.jar",
            "%.war",
            "%.ear",
            "%.zip",
            "%.tar",
            "%.tar%.gz",
            "%.rar",
            "%.7z",
            "%.pdf",
            "%.doc",
            "%.docx",
            "%.xls",
            "%.xlsx",
            "%.ppt",
            "%.pptx",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.gif",
            "%.bmp",
            "%.tiff",
            "%.ico",
            "%.mp3",
            "%.mp4",
            "%.avi",
            "%.mov",
            "%.wmv",
            "%.flv",
          },

          -- 键盘映射
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },

        -- 特定搜索器配置
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
          live_grep = {
            theme = "ivy",
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
          },
          colorscheme = {
            enable_preview = true,
          },
        },

        -- 扩展配置
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            mappings = {
              ["i"] = {},
              ["n"] = {},
            },
          },
        },
      })

      -- 安全加载扩展（添加错误处理）
      local function safe_load_extension(ext_name)
        local success, error_msg = pcall(telescope.load_extension, ext_name)
        if not success then
          vim.notify("Failed to load Telescope extension: " .. ext_name .. " - " .. tostring(error_msg), vim.log.levels.WARN)
        end
      end

      -- 加载扩展
      safe_load_extension("fzf")
      safe_load_extension("ui-select")
      safe_load_extension("file_browser")
      -- projects 扩展将由 project.nvim 插件自动加载
    end,
  },
} 