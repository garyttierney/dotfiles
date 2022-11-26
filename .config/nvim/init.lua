-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Expand LSP text transformations
  use 'L3MON4D3/LuaSnip'

  -- Replace vim.ui.input and vim.ui.select
  use 'stevearc/dressing.nvim'

  -- Show icons for completion items
  use 'onsails/lspkind.nvim'
  use 'windwp/nvim-autopairs'

  -- Fancy quickfix alternative
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons"
  }

  -- Multi-line virtual text diagnostics
  use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", as = "lsp_lines" }

  -- Tab bar
  use {
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- File explorer pane
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  -- LSP inlay hint renderer
  use 'lvimuser/lsp-inlayhints.nvim'

  -- Show popup describing key mappings
  use "folke/which-key.nvim"

  -- Git integration
  use 'tpope/vim-fugitive'

  -- Add git related info in the signs columns and popup
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Highlight and navigate code
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitte
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = { 'nvim-treesitter' }
  }

  -- Collection of configurations for built-in LSP client
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp-document-symbol'
    }
  }

  -- Detect tabstop and shiftwidth automatically
  use 'tpope/vim-sleuth'

  -- Color scheme, and auto-generate missing LSP highlight groups
  use 'folke/tokyonight.nvim'
  use 'folke/lsp-colors.nvim'

  -- Fuzzy Finder (files, lsp, etc)
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable "make" == 1
  }

  -- LSP server for Cargo.toml
  use {
    'saecki/crates.nvim',
    tag = 'v0.3.0',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', {
  clear = true
})

vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC'
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Disable line wrapping
vim.wo.wrap = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease amount of time to wait before completing a key mapping
vim.opt.timeoutlen = 300

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes:3'

-- Set colorscheme and font
vim.o.termguicolors = true
vim.cmd [[colorscheme tokyonight-moon]]

-- Show line breaks when wrapping
vim.opt.showbreak = '↪ '

-- Show whitespace as special characters
vim.opt.list = true
vim.opt.listchars = 'tab:» ,extends:›,precedes:‹,nbsp:·,trail:·'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Use system clipboard as default register
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

-- Block cursor for visual mode, bar otherwise
vim.opt.guicursor:append { 'v:block-Cursor', 'n-i-c:ver100-iCursor' }

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', {
  clear = true
})
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*'
})

-- Load this first, it defines <leader>
require('key-mapping').setup()

-- Automatically close delimiters
require('nvim-autopairs').setup({
  check_ts = true
})

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

require('laf').setup()
require('lsp').setup()
require('lsp-nvim-lua').setup()
require('lsp-rust').setup()
require('navigation').setup()
require('terminal').setup()
require('treesitter-config').setup()
require('workspace').setup()

-- Load this last, it depends on LSP components
require('completion').setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
