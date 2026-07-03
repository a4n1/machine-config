{ ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      border = {
        width = 1;
        radius = 0;
      };
    };
  };

  stylix.targets.fuzzel = {
    enable = true;
    fonts.enable = false;
  };
}
