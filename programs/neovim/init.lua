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

vim.api.nvim_set_keymap('n', '<Tab>', ':Buffers<CR>', { noremap = true, silent = true });
vim.api.nvim_set_keymap('n', '<Leader>s', ':GFiles<CR>', { noremap = true, silent = true });
vim.api.nvim_set_keymap('n', '<Leader>S', ':Files<CR>', { noremap = true, silent = true });

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

require'lspconfig'.ts_ls.setup({})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<C-r>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<C-F>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', '<C-A>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
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
