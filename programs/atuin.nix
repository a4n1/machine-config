{ ... }: {
  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      dialect = "uk";
      inline_height = 20;
      keymap_mode = "vim-insert";
      keymap_cursor = { 
        emacs = "blink-block";
        vim_insert = "steady-bar"; 
        vim_normal = "steady-block";
      };
    };
  };
}
