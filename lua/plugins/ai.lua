-- ========================================
-- AI 编程助手插件配置
-- ========================================

return {
  -- GitHub Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      
      -- 自定义快捷键
      local keymap = vim.keymap.set
      keymap("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion"
      })
      keymap("i", "<C-;>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })
      keymap("i", "<C-,>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
      keymap("i", "<C-.>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
      keymap("i", "<C-o>", "<Plug>(copilot-suggest)", { desc = "Request Copilot suggestion" })
      
      -- 文件类型配置
      vim.g.copilot_filetypes = {
        ["*"] = false,
        ["javascript"] = true,
        ["typescript"] = true,
        ["lua"] = true,
        ["rust"] = true,
        ["c"] = true,
        ["c#"] = true,
        ["c++"] = true,
        ["go"] = true,
        ["python"] = true,
        ["java"] = true,
        ["kotlin"] = true,
        ["php"] = true,
        ["ruby"] = true,
        ["swift"] = true,
        ["vim"] = true,
        ["zsh"] = true,
        ["sh"] = true,
        ["fish"] = true,
      }
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    keys = {
      { "<leader>cch", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
      { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "Review code" },
      { "<leader>ccf", "<cmd>CopilotChatFix<cr>", desc = "Fix code" },
      { "<leader>cco", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>ccd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        show_help = "yes",
        auto_follow_cursor = false,
        insert_at_end = false,
        question_header = "## User ",
        answer_header = "## Copilot ",
        error_header = "## Error ",
        separator = " ",
        prompts = {
          Explain = {
            prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
          },
          Review = {
            prompt = "/COPILOT_REVIEW Review the selected code.",
            callback = function(response, source)
            end,
          },
          Fix = {
            prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
          },
          Optimize = {
            prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
          },
          Docs = {
            prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
          },
          Tests = {
            prompt = "/COPILOT_GENERATE Please generate tests for my code.",
          },
          FixDiagnostic = {
            prompt = "Please assist with the following diagnostic issue in file:",
            selection = require("CopilotChat.select").diagnostics,
          },
          Commit = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = require("CopilotChat.select").gitdiff,
          },
          CommitStaged = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = function(source)
              return require("CopilotChat.select").gitdiff(source, true)
            end,
          },
        },
        window = {
          layout = "vertical",
          width = 0.5,
          height = 0.5,
          relative = "editor",
          border = "single",
          title = "Copilot Chat",
          footer = nil,
          zindex = 1,
        },
        mappings = {
          complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
          },
          close = {
            normal = "q",
            insert = "<C-c>"
          },
          reset = {
            normal = "<C-r>",
            insert = "<C-r>"
          },
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-s>"
          },
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>"
          },
          yank_diff = {
            normal = "gy",
            register = '"',
          },
          show_diff = {
            normal = "gd"
          },
          show_system_prompt = {
            normal = "gp"
          },
          show_user_selection = {
            normal = "gs"
          },
        },
      })
    end,
  },

  -- Codeium (免费的 Copilot 替代品)
  {
    "Exafunction/codeium.vim",
    enabled = false, -- 设置为 true 来启用，建议禁用 Copilot 以避免冲突
    event = "BufEnter",
    config = function()
      -- 如果启用 Codeium，建议同时禁用 GitHub Copilot
      -- 将上面的 github/copilot.vim 的 enabled 设置为 false
      
      vim.g.codeium_disable_bindings = 1
      
      -- 自定义快捷键 (与 Copilot 类似的体验)
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true, desc = "Accept Codeium suggestion" })
      vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true, desc = "Next Codeium suggestion" })
      vim.keymap.set('i', '<C-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true, desc = "Previous Codeium suggestion" })
      vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true, desc = "Clear Codeium suggestion" })
      
      -- 启用/禁用 Codeium 的快捷键
      vim.keymap.set('n', '<leader>ce', '<cmd>call codeium#Chat()<cr>', { desc = "Open Codeium Chat" })
      vim.keymap.set('n', '<leader>cd', '<cmd>call codeium#CycleOrComplete()<cr>', { desc = "Codeium Cycle or Complete" })
    end
  },

  -- ChatGPT.nvim
  {
    "jackMort/ChatGPT.nvim",
    enabled = false, -- 设置为 true 来启用，需要配置 OPENAI_API_KEY 环境变量
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun translate<CR>", desc = "Translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit", mode = { "n", "v" } },
      { "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis", mode = { "n", "v" } },
    },
    config = function()
      -- 你需要设置环境变量 OPENAI_API_KEY
      -- 在 Windows PowerShell 中: $env:OPENAI_API_KEY="your-api-key-here"
      -- 在 Windows CMD 中: set OPENAI_API_KEY=your-api-key-here
      -- 或者在配置中直接设置: api_key_cmd = "echo your-api-key-here"
      
      require("chatgpt").setup({
        api_key_cmd = nil, -- 使用环境变量 OPENAI_API_KEY
        yank_register = "+",
        edit_with_instructions = {
          diff = false,
          keymaps = {
            close = "<C-c>",
            accept = "<C-y>",
            toggle_diff = "<C-d>",
            toggle_settings = "<C-o>",
            cycle_windows = "<Tab>",
            use_output_as_input = "<C-i>",
          },
        },
        chat = {
          welcome_message = "Welcome to ChatGPT",
          loading_text = "Loading, please wait ...",
          question_sign = "",
          answer_sign = "ﮧ",
          max_line_length = 120,
          sessions_window = {
            border = {
              style = "rounded",
              text = {
                top = " Sessions ",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          },
          keymaps = {
            close = { "<C-c>" },
            yank_last = "<C-y>",
            yank_last_code = "<C-k>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
            cycle_modes = "<C-f>",
            select_session = "<Space>",
            rename_session = "r",
            delete_session = "d",
            draft_message = "<C-d>",
            toggle_settings = "<C-o>",
            toggle_message_role = "<C-r>",
            toggle_system_role_open = "<C-s>",
            stop_generating = "<C-x>",
          },
        },
        popup_layout = {
          default = "center",
          center = {
            width = "80%",
            height = "80%",
          },
          right = {
            width = "30%",
            width_settings_open = "50%",
          },
        },
        popup_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " ChatGPT ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "1",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          buf_options = {
            filetype = "markdown",
          },
        },
        system_window = {
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top = " SYSTEM ",
            },
          },
          win_options = {
            wrap = true,
            linebreak = true,
            foldcolumn = "2",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        popup_input = {
          prompt = "  ",
          border = {
            highlight = "FloatBorder",
            style = "rounded",
            text = {
              top_align = "center",
              top = " Prompt ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
          submit = "<C-Enter>",
          submit_n = "<Enter>",
          max_visible_lines = 20
        },
        settings_window = {
          border = {
            style = "rounded",
            text = {
              top = " Settings ",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        openai_edit_params = {
          model = "code-davinci-edit-001",
          temperature = 0,
          top_p = 1,
          n = 1,
        },
        actions_paths = {},
        show_quickfixes_cmd = "Trouble quickfix",
        predefined_chat_gpt_prompts = "https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/main/prompts.csv",
      })
    end,
  },
} 