{ ... }: {
  imports = [
    ./niri
    ./awww.nix
    ./fuzzel.nix
  ];

  services.ssh-agent.enable = true;

  stylix.targets = {
    neovim.enable = false;
    tmux.enable = false;
  };
}

