vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.backup = false
vim.g.writebackup = false
vim.g.swapfile = false
vim.g.rustfmt_autosave = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.wrap = false

vim.cmd('filetype plugin indent on')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_augroup("ForcePermissions", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "ForcePermissions",
  pattern = "*",
  command = "silent! !chmod 644 <afile>",
})

require('catppuccin').setup({
    flavour = 'mocha',
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = false,
    default_integrations = true,
    integrations = {
        cmp = true,
        treesitter = true,
    },
})

vim.cmd.colorscheme('catppuccin')

require('lspconfig').rust_analyzer.setup({
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = 'clippy',
      },
    },
   },
})

require('cmp').setup {
  mapping = require('cmp').mapping.preset.insert({
    ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
    ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
    ['<C-Space>'] = require('cmp').mapping.complete(),
    ['<C-e>'] = require('cmp').mapping.abort(),
    ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
  }),
  sources = require('cmp').config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
}

require('cmp_nvim_lsp').default_capabilities()
