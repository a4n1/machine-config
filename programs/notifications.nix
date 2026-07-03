{ pkgs, ... }: {
  home.packages = with pkgs; [
    libnotify
  ];

  services.mako.enable = true;

  stylix.targets.mako = {
    enable = true;
    fonts.enable = false;
  };
}
