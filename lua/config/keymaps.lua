-- ========================================
-- 键盘映射配置
-- ========================================

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- 基础映射
keymap.set("n", "<C-h>", "<C-w>h", opts) -- 窗口导航
keymap.set("n", "<C-j>", "<C-w>j", opts)
keymap.set("n", "<C-k>", "<C-w>k", opts)
keymap.set("n", "<C-l>", "<C-w>l", opts)

-- 分屏操作
keymap.set("n", "<leader>sv", "<C-w>v", opts) -- 垂直分屏
keymap.set("n", "<leader>sh", "<C-w>s", opts) -- 水平分屏
keymap.set("n", "<leader>se", "<C-w>=", opts) -- 等分窗口
keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts) -- 关闭当前窗口

-- 缓冲区操作
keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts) -- 上一个缓冲区
keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts) -- 下一个缓冲区
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", opts) -- 删除缓冲区

-- 标签页操作
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", opts) -- 新建标签页
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts) -- 关闭标签页
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", opts) -- 下一个标签页
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", opts) -- 上一个标签页

-- 缩进保持选择
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)

-- 移动选中文本
keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- 搜索相关
keymap.set("n", "<leader>nh", ":nohl<CR>", opts) -- 清除搜索高亮

-- 快速保存和退出
keymap.set("n", "<leader>w", "<cmd>w<CR>", opts)
keymap.set("n", "<leader>q", "<cmd>q<CR>", opts)
keymap.set("n", "<leader>wq", "<cmd>wq<CR>", opts)

-- 更好的上下移动
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 中央化搜索结果
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- 更好的粘贴 (保持寄存器内容)
keymap.set("v", "p", '"_dP', opts)

-- 快速添加空行
keymap.set("n", "<leader>o", "o<Esc>", opts)
keymap.set("n", "<leader>O", "O<Esc>", opts)

-- 选择全部
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- 终端模式映射
keymap.set("t", "<Esc>", "<C-\\><C-n>", opts) -- 退出终端模式
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

-- Unicode 和字符编码相关
keymap.set("n", "<leader>ut", "<cmd>UnicodeTest<CR>", { desc = "Unicode 测试" })
keymap.set("n", "<leader>ue", "<cmd>ShowEncoding<CR>", { desc = "显示编码信息" })
keymap.set("n", "<leader>uc", "<cmd>ConvertEncoding<CR>", { desc = "转换文件编码" })
keymap.set("n", "<leader>uf", "<cmd>FontTest<CR>", { desc = "字体测试" })

-- 特殊字符快速插入 (插入模式)
keymap.set("i", "<C-e>", "", { desc = "插入 emoji", noremap = true })
keymap.set("i", "<A-space>", " ", { desc = "插入不间断空格", noremap = true })

-- 字符编码快速切换
keymap.set("n", "<leader>u8", "<cmd>ConvertEncoding utf-8<CR>", { desc = "转换为 UTF-8" })
keymap.set("n", "<leader>ug", "<cmd>ConvertEncoding gbk<CR>", { desc = "转换为 GBK" })

-- 插件管理和诊断
keymap.set("n", "<leader>pc", "<cmd>CheckPlugins<CR>", { desc = "检查插件状态" })
keymap.set("n", "<leader>pf", "<cmd>FixPlugins<CR>", { desc = "修复插件问题" })
keymap.set("n", "<leader>pi", "<cmd>Lazy install<CR>", { desc = "安装插件" })
keymap.set("n", "<leader>pu", "<cmd>Lazy update<CR>", { desc = "更新插件" }) 