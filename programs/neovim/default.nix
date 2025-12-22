{ pkgs, ...}: {
  programs.neovim = {
    enable = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      blink-cmp
      tiny-inline-diagnostic-nvim
      fzf-lua
      vim-commentary
      gitsigns-nvim
      rust-vim
      vim-nix
      tabular
      neoformat
    ];
  };
}
