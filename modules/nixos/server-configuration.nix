{ system, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = system.hostname;
   
  users.users.root.hashedPassword = "!";
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    blesh
    git
    neovim
    tmux
    tree
    gnumake
    gnupg
    tailscale
  ];

  services.tailscale.enable = true;
}


