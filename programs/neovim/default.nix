{ config, pkgs, self, ...}: {
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      playground
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      vim-surround
      vim-unimpaired
      vim-repeat
      vim-fugitive
      rust-vim
      vim-nix
      tabular
      fzf-vim
      leap-nvim
    ];
  };
}
