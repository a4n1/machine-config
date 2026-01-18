{ system, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  users.users.${system.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
   
  networking.firewall.allowedTCPPorts = [ 22 ];

  system.stateVersion = "25.05";
}
