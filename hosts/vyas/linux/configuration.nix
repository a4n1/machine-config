{ system, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  networking.networkmanager.enable = true;
  users.users.${system.username}.extraGroups = [ "networkmanager" ];

  system.stateVersion = "24.05";
}
