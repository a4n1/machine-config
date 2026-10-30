{ ... }: {
  imports = [
    ./niri
    ./wpaperd.nix
    ./fuzzel.nix
    ./notifications.nix
    ./kanshi.nix
  ];

  services.ssh-agent.enable = true;

  home.pointerCursor.enable = true;

  stylix.targets = {
    neovim.enable = false;
    tmux.enable = false;
    firefox.enable = true;
  };
}
