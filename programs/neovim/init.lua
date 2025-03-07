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
vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end
})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<Leader>e', vim.cmd.Ex) 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set({"n", "v"}, "<Leader>y", [["+y]])
vim.keymap.set("n", "<Leader>Y", [["+Y]])
vim.keymap.set({"n", "v"}, '<Leader>p', '"+p', { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, '<Leader>P', '"+P', { noremap = true, silent = true })
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })
vim.keymap.set({"n", "v"}, "<Leader>d", "\"_d")
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<Leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

vim.keymap.set("n", '<Leader>b', ':Buffers<CR>', { noremap = true, silent = true })
vim.keymap.set("n", '<Leader>f', ':GFiles<CR>', { noremap = true, silent = true })
vim.keymap.set("n", '<Leader>F', ':Files<CR>', { noremap = true, silent = true })
vim.keymap.set("n", '<C-f>', ':RG<CR>', { noremap = true, silent = true })

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
});

require'lspconfig'.ts_ls.setup({});

require'lspconfig'.nixd.setup({});

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>')
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    bufmap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    bufmap('n', 'gf', '<cmd>lua vim.diagnostic.open_float()<cr>')
    bufmap('n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>')
    bufmap('n', '<Leader>m', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', '<C-Space>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
});

require('cmp').setup({
  mapping = require('cmp').mapping.preset.insert({
    ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
    ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
    ['<C-Space>'] = require('cmp').mapping.complete(),
    ['<C-e>'] = require('cmp').mapping.abort(),
    ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
  }),
  sources = require('cmp').config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
});

require('cmp_nvim_lsp').default_capabilities()

vim.g.neoformat_try_node_exe = true;
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.js,*.ts,*.jsx,*.tsx',
  command = 'Neoformat',
});

gitsigns = require('gitsigns');

gitsigns.setup();
vim.keymap.set({'n', 'v'}, '<leader>gs', gitsigns.stage_hunk);
vim.keymap.set({'n', 'v'}, '<leader>gu', gitsigns.undo_stage_hunk);
vim.keymap.set({'n', 'v'}, '<leader>gr', gitsigns.reset_hunk);
vim.keymap.set({'n', 'v'}, '<leader>gS', gitsigns.stage_buffer);
vim.keymap.set({'n', 'v'}, '<leader>gR', gitsigns.reset_buffer);

if vim.fn.executable('node') ~= 0 then
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  });

  require('copilot_cmp').setup();
end
