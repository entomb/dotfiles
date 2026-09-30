-- Load the upstream plugin framework, then our actual custom settings.
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
  if vim.v.shell_error ~= 0 then error("Unable to load lazy.nvim: " .. result) end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "AstroNvim/AstroNvim",
    version = "^6",
    import = "astronvim.plugins",
    opts = { mapleader = " ", maplocalleader = ",", icons_enabled = true },
  },
}
vim.list_extend(plugins, dofile(vim.fn.stdpath("config") .. "/config.lua"))
require("lazy").setup(plugins, {
  install = { colorscheme = { "astrotheme", "habamax" } },
  ui = { backdrop = 100 },
  performance = { rtp = { disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "zipPlugin" } } },
})
