{ config, ... }: {
  imports = [
    ./niri
    ./wpaperd.nix
    ./fuzzel.nix
    ./notifications.nix
    ./kanshi.nix
  ];

  services.ssh-agent.enable = true;

  home.pointerCursor.enable = true;

  programs.firefox.configPath = ".mozilla/firefox";

  dconf.settings."org/gnome/desktop/interface".color-scheme =
    if config.stylix.polarity == "dark" then "prefer-dark" else "default";

  stylix.targets = {
    gtk.enable = true;
    neovim.enable = false;
    tmux.enable = false;
    firefox = {
      enable = true;
      profileNames = [ "default" ];
    };
  };
}
