-- ========================================
-- 自动命令配置
-- ========================================

-- 自动命令组
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 通用设置组
local general = augroup("General", { clear = true })

-- 高亮复制内容
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 300 })
  end,
})

-- 自动保存时去除尾随空格
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- 进入终端时自动进入插入模式
autocmd("TermOpen", {
  group = general,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- 文件类型特定设置
local filetype_settings = augroup("FiletypeSettings", { clear = true })

-- Lua 文件设置
autocmd("FileType", {
  group = filetype_settings,
  pattern = "lua",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Python 文件设置
autocmd("FileType", {
  group = filetype_settings,
  pattern = "python",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})

-- 项目管理相关
local project_group = augroup("ProjectManagement", { clear = true })

-- 创建项目管理用户命令
vim.api.nvim_create_user_command("FindProjects", function()
  -- 尝试使用 projects 扩展
  local success = pcall(vim.cmd, "Telescope projects")
  if not success then
    -- 回退到在常见项目目录搜索
    local project_dirs = {
      vim.fn.expand("~"),
      vim.fn.expand("~/Documents"),
      vim.fn.expand("~/Desktop"),
      vim.fn.expand("~/projects"),
      "C:\\Users\\Administrator\\Documents",
      "C:\\Users\\Administrator\\Desktop"
    }
    
    for _, dir in ipairs(project_dirs) do
      if vim.fn.isdirectory(dir) == 1 then
        require('telescope.builtin').find_files({ cwd = dir })
        break
      end
    end
  end
end, { desc = "Find and switch to projects" })

-- 自动检测项目根目录
autocmd({ "BufRead", "BufNewFile" }, {
  group = project_group,
  callback = function()
    local root_patterns = { '.git', '.hg', '.svn', 'package.json', 'Makefile', 'pyproject.toml' }
    local root_dir = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
    if root_dir then
      vim.cmd("cd " .. root_dir)
    end
  end,
})

-- Unicode 和 emoji 支持测试
local unicode_group = augroup("UnicodeSupport", { clear = true })

-- 创建 Unicode 测试命令
vim.api.nvim_create_user_command("UnicodeTest", function()
  local test_content = {
    "# Unicode 和 Emoji 支持测试",
    "",
    "## 基本 Unicode 字符",
    "中文: 你好世界 🌍",
    "日文: こんにちは 🗾", 
    "韩文: 안녕하세요 🇰🇷",
    "俄文: Привет мир 🇷🇺",
    "阿拉伯文: مرحبا بالعالم 🌙",
    "",
    "## Emoji 测试",
    "表情: 😀 😃 😄 😁 😆 😅 😂 🤣",
    "动物: 🐶 🐱 🐭 🐹 🐰 🦊 🐻 🐼",
    "食物: 🍎 🍌 🍕 🍔 🍟 🍗 🍖 🥕",
    "活动: ⚽ 🏀 🏈 ⚾ 🎾 🏐 🏉 🎱",
    "",
    "## 特殊符号",
    "数学: ∑ ∏ ∫ ∂ ∆ ∇ ± × ÷ ≈ ≠ ≤ ≥",
    "箭头: ← → ↑ ↓ ↖ ↗ ↘ ↙ ⇄ ⇅ ⇆ ⇇",
    "图形: ■ □ ▲ △ ● ○ ◆ ◇ ★ ☆ ♠ ♣ ♥ ♦",
    "",
    "## 编程相关",
    "Git: 🔀 🔁 📝 🐛 ✨ 🚀 🔧 📚",
    "状态: ✅ ❌ ⚠️ ℹ️ 🔄 ⏳ 💡 🎯",
    "",
    "如果以上字符都能正常显示，说明 Unicode 支持已正确配置！"
  }
  
  -- 创建新缓冲区
  vim.cmd("enew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, test_content)
  vim.bo.filetype = "markdown"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  print("Unicode 测试文件已创建！检查字符是否正确显示")
end, { desc = "创建 Unicode 和 emoji 测试文件" })

-- 字符编码检测和转换命令
vim.api.nvim_create_user_command("ShowEncoding", function()
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local format = vim.bo.fileformat
  local bomb = vim.bo.bomb and "BOM" or "noBOM"
  
  print(string.format("编码: %s | 格式: %s | %s", encoding, format, bomb))
end, { desc = "显示当前文件编码信息" })

-- 转换文件编码命令
vim.api.nvim_create_user_command("ConvertEncoding", function(opts)
  local target_encoding = opts.args ~= "" and opts.args or "utf-8"
  vim.bo.fileencoding = target_encoding
  print("文件编码已设置为: " .. target_encoding)
end, { 
  nargs = "?", 
  complete = function()
    return {"utf-8", "gbk", "gb2312", "big5", "latin1"}
  end,
  desc = "转换文件编码" 
})

-- 字体测试命令
vim.api.nvim_create_user_command("FontTest", function()
  local test_fonts = {
    "JetBrains Mono Nerd Font",
    "Fira Code Nerd Font", 
    "Source Code Pro Nerd Font",
    "Cascadia Code PL",
    "Consolas NF"
  }
  
  print("推荐的支持 Unicode 和 emoji 的字体:")
  for i, font in ipairs(test_fonts) do
    print(string.format("%d. %s", i, font))
  end
  print("\n在终端设置中选择这些字体以获得最佳 Unicode 支持")
end, { desc = "显示推荐的 Unicode 字体" })

-- 插件构建状态检查
vim.api.nvim_create_user_command("CheckPlugins", function()
  print("=== 插件状态检查 ===")
  
  -- 检查 LuaSnip
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if luasnip_ok then
    print("✅ LuaSnip: 已加载")
  else
    print("❌ LuaSnip: 加载失败")
  end
  
  -- 检查 markdown-preview
  local mkdp_available = vim.fn.exists(":MarkdownPreview") == 2
  if mkdp_available then
    print("✅ Markdown Preview: 可用")
  else
    print("❌ Markdown Preview: 不可用")
  end
  
  -- 检查 code_runner
  local code_runner_ok, _ = pcall(require, "code_runner")
  if code_runner_ok then
    print("✅ Code Runner: 已加载")
  else
    print("❌ Code Runner: 加载失败")
  end
  
  -- 检查 Node.js (markdown-preview 需要)
  local node_available = vim.fn.executable("node") == 1
  if node_available then
    print("✅ Node.js: 已安装")
  else
    print("⚠️  Node.js: 未找到 (Markdown 预览需要)")
  end
  
  -- 检查 npm
  local npm_available = vim.fn.executable("npm") == 1
  if npm_available then
    print("✅ npm: 已安装")
  else
    print("⚠️  npm: 未找到 (Markdown 预览需要)")
  end
  
  print("\n如果有问题，请运行 :FixPlugins 尝试修复")
end, { desc = "检查插件构建状态" })

-- 插件修复命令
vim.api.nvim_create_user_command("FixPlugins", function()
  print("=== 尝试修复插件问题 ===")
  
  -- 尝试手动构建 markdown-preview
  local mkdp_path = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim"
  if vim.fn.isdirectory(mkdp_path) == 1 then
    print("修复 Markdown Preview...")
    local cmd = vim.fn.has("win32") == 1 and 
      "cd " .. mkdp_path .. "/app && npm install" or
      "cd " .. mkdp_path .. " && npm install"
    vim.fn.system(cmd)
    print("Markdown Preview 修复完成")
  end
  
  -- 重新加载插件
  print("重新加载插件配置...")
  vim.cmd("Lazy reload")
  
  print("修复完成！请重启 Neovim 以确保更改生效")
end, { desc = "尝试修复插件构建问题" })

-- 进入插入模式时取消搜索高亮
augroup("ClearSearchOnInsert", { clear = true })
autocmd("InsertEnter", {
  group = "ClearSearchOnInsert",
  pattern = "*",
  command = "set nohlsearch",
})

-- 自动保存文件
augroup("AutoSave", { clear = true })
autocmd({ "FocusLost", "BufLeave" }, {
  group = "AutoSave",
  pattern = "*",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command("silent update")
    end
  end,
})

-- 自动切换到文件所在目录
augroup("AutoChdir", { clear = true })
autocmd("BufEnter", {
  group = "AutoChdir",
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("silent! lcd %:p:h")
    end
  end,
})

-- 记住文件位置
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 自动调整窗口大小
augroup("ResizeWindows", { clear = true })
autocmd("VimResized", {
  group = "ResizeWindows",
  pattern = "*",
  command = "tabdo wincmd =",
})

-- 关闭某些文件类型的行号
augroup("DisableNumbersForCertainFiletypes", { clear = true })
autocmd("FileType", {
  group = "DisableNumbersForCertainFiletypes",
  pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
  end,
})

-- 快速关闭某些文件类型
augroup("QuickClose", { clear = true })
autocmd("FileType", {
  group = "QuickClose",
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- 检查文件外部更改
augroup("CheckFileChanges", { clear = true })
autocmd({ "BufEnter", "FocusGained" }, {
  group = "CheckFileChanges",
  pattern = "*",
  command = "checktime",
}) 