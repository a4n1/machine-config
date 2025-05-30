vim.loader.enable()

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
vim.api.nvim_create_augroup('FileTypeSettings', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = {'javascript', 'typescript', 'typescriptreact', 'javascriptreact'},
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end
})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-c>', '<cmd>ccl<Bar>nohlsearch<CR>',
               {noremap = true, silent = true})
vim.keymap.set('n', '<Leader>e', '<cmd>Ex<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Leader>e', vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set({'n', 'v'}, '<Leader>y', [["+y]])
vim.keymap.set('n', '<Leader>Y', [["+Y]])
vim.keymap.set({'n', 'v'}, '<Leader>p', '"+p', {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<Leader>P', '"+P', {noremap = true, silent = true})
vim.keymap.set('v', 'p', '"_dP', {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<Leader>d', '"_d')
vim.keymap.set('i', '<C-c>', '<Esc>')
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('v', '>', '>gv', {noremap = true, silent = true})
vim.keymap.set('v', '<', '<gv', {noremap = true, silent = true})

local fzfLua = require('fzf-lua')

fzfLua.setup({
  'hide',
  winopts = {
    height = 0.7,
    width = 0.8,
    row = 0.5,
    col = 0.5,
    preview = {scrollbar = false}
  },
  fzf_opts = {['--layout'] = 'reverse-list'}
})

vim.keymap
    .set('n', '<Leader>b', fzfLua.buffers, {noremap = true, silent = true})
vim.keymap.set('n', '<Leader>f', fzfLua.git_files,
               {noremap = true, silent = true})
vim.keymap.set('n', '<Leader>F', fzfLua.files, {noremap = true, silent = true})
vim.keymap.set('n', '<C-f>', fzfLua.live_grep_resume,
               {noremap = true, silent = true})

require('catppuccin').setup({
  flavour = 'mocha',
  transparent_background = true,
  show_end_of_buffer = false,
  term_colors = false,
  default_integrations = true,
  integrations = {gitsigns = true, blink_cmp = true, treesitter = true}
})

vim.cmd.colorscheme('catppuccin')

local capabilities = require('blink.cmp').get_lsp_capabilities()

require('lspconfig').lua_ls.setup({
  capabilities = capabilities,
  settings = {Lua = {diagnostics = {globals = {'vim'}}}}
})

require('lspconfig').rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      cargo = {allFeatures = true},
      checkOnSave = {command = 'clippy'}
    }
  }
})

require('lspconfig').ts_ls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    if filetype == 'javascript' or filetype == 'javascriptreact' then
      client.config.init_options = client.config.init_options or {}
      client.config.init_options.preferences =
          client.config.init_options.preferences or {}
      client.config.init_options.preferences['checkJs'] = false
    end
  end,
  init_options = {preferences = {checkJs = false}}
})

require('lspconfig').nixd.setup({capabilities = capabilities})

require('tiny-inline-diagnostic').setup({
  preset = 'classic',
  transparent_bg = true,
  transparent_cursorline = true
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    bufmap('n', 'gk', vim.lsp.buf.hover)
    bufmap('n', 'gd', vim.lsp.buf.definition)
    bufmap('n', 'gi', vim.lsp.buf.implementation)
    bufmap('n', 'gr', vim.lsp.buf.references)
    bufmap('n', 'gs', vim.lsp.buf.signature_help)
    bufmap('n', '<Leader>r', vim.lsp.buf.rename)
    bufmap('n', '<Leader>m', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
    bufmap('n', 'g.', fzfLua.lsp_code_actions)
    bufmap('n', '[d', vim.diagnostic.goto_prev)
    bufmap('n', ']d', vim.diagnostic.goto_next)
  end
})

require('blink.cmp').setup({
  keymap = {preset = 'super-tab'},
  sources = {default = {'lsp', 'path', 'snippets', 'buffer'}}
})

vim.g.neoformat_try_node_exe = true
vim.g.neoformat_enabled_lua = {'lua_format'}
vim.g.neoformat_lua_lua_format = {
  exe = 'lua-format',
  args = {'--indent-width', 2},
  stdin = true
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.js,*.ts,*.jsx,*.tsx,*.json,*.lua',
  command = 'Neoformat'
})

local gitsigns = require('gitsigns')

gitsigns.setup()
vim.keymap.set({'n', 'v'}, '<leader>gs', gitsigns.stage_hunk)
vim.keymap.set({'n', 'v'}, '<leader>gu', gitsigns.undo_stage_hunk)
vim.keymap.set({'n', 'v'}, '<leader>gr', gitsigns.reset_hunk)
vim.keymap.set({'n', 'v'}, '<leader>gS', gitsigns.stage_buffer)
vim.keymap.set({'n', 'v'}, '<leader>gR', gitsigns.reset_buffer)
vim.keymap.set({'n', 'v'}, '<leader>gd', gitsigns.preview_hunk_inline)
vim.keymap.set({'n', 'v'}, '<leader>gb', gitsigns.toggle_current_line_blame)
vim.keymap.set('n', ']c', '<cmd>lua gitsigns.nav_hunk("next")<cr>')
vim.keymap.set('n', ']c', '<cmd>lua gitsigns.nav_hunk("prev")<cr>')
