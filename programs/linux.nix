{ ... }: {
  imports = [
    ./niri
    ./wpaperd.nix
    ./fuzzel.nix
  ];

  services.ssh-agent.enable = true;

  stylix.targets = {
    neovim.enable = false;
    tmux.enable = false;
    firefox.enable = true;
  };
}
