-- ========================================
-- 代码补全系统配置
-- ========================================

return {
  -- 补全引擎
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",        -- 缓冲区补全
      "hrsh7th/cmp-path",          -- 路径补全
      "hrsh7th/cmp-nvim-lsp",      -- LSP 补全
      "hrsh7th/cmp-nvim-lua",      -- Lua API 补全
      "hrsh7th/cmp-cmdline",       -- 命令行补全
      "saadparwaiz1/cmp_luasnip",  -- 片段补全
      "hrsh7th/cmp-calc",          -- 计算器补全
      "hrsh7th/cmp-emoji",         -- 表情符号补全
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- 检查是否有词在前面
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      -- 图标配置
      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- 设置图标
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            
            -- 设置来源
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
              nvim_lua = "[Lua]",
              calc = "[Calc]",
              emoji = "[Emoji]",
            })[entry.source.name]
            
            return vim_item
          end,
        },

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
          { name = "nvim_lua" },
          { name = "calc" },
          { name = "emoji" },
        }),

        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      })

      -- 命令行补全配置
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          { name = "cmdline" }
        })
      })
    end,
  },

  -- 代码片段引擎
  {
    "L3MON4D3/LuaSnip",
    build = function()
      -- Windows 环境下跳过 jsregexp 构建，避免编译错误
      if vim.fn.has("win32") == 1 then
        return "echo 'Skipping jsregexp build on Windows'"
      else
        return "make install_jsregexp"
      end
    end,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require("luasnip")
      
      -- 加载 friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- 自定义片段目录
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
      
      luasnip.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        -- 禁用需要 jsregexp 的功能以避免错误
        enable_autosnippets = false,
      })

      -- 片段跳转键映射
      vim.keymap.set({"i"}, "<C-K>", function() luasnip.expand() end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-L>", function() luasnip.jump( 1) end, {silent = true})
      vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(-1) end, {silent = true})

      vim.keymap.set({"i", "s"}, "<C-E>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end, {silent = true})
    end,
  },

  -- 自动配对
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")

      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })

      -- CMP 集成
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- 友好的代码片段
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
} 