-- ========================================
-- Neovim 基础选项配置
-- ========================================

local opt = vim.opt

-- 编辑体验
opt.number = true              -- 显示行号
opt.relativenumber = true      -- 显示相对行号
opt.cursorline = true         -- 高亮当前行
opt.signcolumn = "yes"        -- 始终显示符号列
opt.wrap = false              -- 不自动换行
opt.scrolloff = 8             -- 垂直滚动时保持8行边距
opt.sidescrolloff = 8         -- 水平滚动时保持8列边距

-- 搜索
opt.hlsearch = true           -- 高亮搜索结果
opt.incsearch = true          -- 增量搜索
opt.ignorecase = true         -- 搜索时忽略大小写
opt.smartcase = true          -- 智能大小写匹配

-- 缩进
opt.tabstop = 2               -- Tab 宽度
opt.softtabstop = 2           -- 软 Tab 宽度
opt.shiftwidth = 2            -- 自动缩进宽度
opt.expandtab = true          -- 使用空格代替 Tab
opt.smartindent = true        -- 智能缩进
opt.autoindent = true         -- 自动缩进

-- 文件处理
opt.hidden = true             -- 允许未保存的缓冲区
opt.backup = false            -- 不创建备份文件
opt.writebackup = false       -- 不创建写入备份
opt.swapfile = false          -- 不创建交换文件
opt.undofile = true           -- 启用持久化撤销
opt.undolevels = 10000        -- 撤销级别

-- UI 增强
opt.pumheight = 10            -- 弹出菜单高度
opt.cmdheight = 1             -- 命令行高度
opt.showtabline = 2           -- 始终显示标签页
opt.laststatus = 3            -- 全局状态栏
opt.splitbelow = true         -- 水平分割在下方
opt.splitright = true         -- 垂直分割在右方

-- 性能优化
opt.updatetime = 300          -- 更新时间
opt.timeoutlen = 300          -- 键映射超时时间
opt.redrawtime = 1500         -- 重绘超时时间

-- 鼠标和剪贴板
opt.mouse = "a"               -- 启用鼠标支持
opt.clipboard = "unnamedplus" -- 使用系统剪贴板

-- 字体和字符编码 (完整 Unicode 支持)
opt.guifont = "JetBrains Mono Nerd Font:h12"

-- 完整的字符编码支持
opt.encoding = "utf-8"                    -- 内部编码使用 UTF-8
opt.fileencoding = "utf-8"               -- 默认文件编码
opt.fileencodings = "utf-8,ucs-bom,gbk,gb2312,gb18030,big5,latin1" -- 文件编码检测顺序
opt.fileformat = "unix"                  -- 默认文件格式
opt.fileformats = "unix,dos,mac"         -- 支持的文件格式

-- 终端和显示优化
if vim.fn.exists('+termguicolors') == 1 then
  opt.termguicolors = true               -- 启用真彩色支持
end

-- Unicode 和 emoji 支持
opt.ambiwidth = "single"                 -- 设置模糊宽度字符为单宽度
opt.emoji = true                         -- 启用 emoji 支持 (Neovim 0.10+)

-- 字符显示优化
vim.g.skip_ts_context_commentstring_module = true  -- 优化上下文注释

-- 设置特殊字符显示
opt.list = true                          -- 显示特殊字符
opt.listchars = {
  tab = "→ ",                           -- Tab 显示为箭头
  eol = "↲",                            -- 行尾显示
  nbsp = "␣",                           -- 不间断空格
  trail = "•",                          -- 尾随空格
  extends = "⟩",                        -- 右侧截断标记
  precedes = "⟨",                       -- 左侧截断标记
  space = " ",                          -- 普通空格
}

-- 字符宽度和显示设置
if vim.fn.has('multi_byte') == 1 then
  opt.formatoptions:append("mM")         -- 处理多字节字符
end

-- 折叠
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false        -- 默认不折叠

-- 补全选项
opt.completeopt = { "menu", "menuone", "noselect" }

-- 会话选项
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" } 