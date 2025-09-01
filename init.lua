-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic options
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.relativenumber = false


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "python", "javascript", "html", "css", "c", "cpp" },
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },
        })
      end,
    },

    {
      "nvim-lualine/lualine.nvim",
      config = function()
        require("lualine").setup({})
      end,
    },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("telescope").setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git" },
          },
        })
      end,
    },


    {
      "neovim/nvim-lspconfig",
      config = function()
        local lspconfig = require("lspconfig")
        -- C/C++ LSP
        lspconfig.clangd.setup({
          cmd = { "clangd" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
        })
      end,
    },

    -- Catppuccin theme
    { 
      "catppuccin/nvim", 
      name = "catppuccin", 
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
    },

    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({})
        vim.keymap.set("n", "<C-n>", ":Neotree toggle left reveal_force_cwd<CR>", { desc = "Toggle Neo-tree (Ctrl+n)" })
      end,
    },
  },

  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep (search text)" })

-- Terminal keymaps
vim.keymap.set("n", "<leader>t", ":split | terminal<CR>", { desc = "Open terminal below" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode with Esc" })
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>:q<CR>]], { desc = "Close terminal with Ctrl+q" })

