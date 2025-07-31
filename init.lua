-- ========================================
-- 现代化 Neovim 配置 - init.lua
-- ========================================

-- 设置 leader 键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 基础配置
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- 初始化 lazy.nvim 插件管理器
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 加载插件配置
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- 总是使用最新版本
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- 自动检查插件更新
})
