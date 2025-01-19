
{ system, ... }: {
  networking.hostName = system.hostname;
  networking.computerName = system.hostname;
  system.defaults.smb.NetBIOSName = system.hostname;

  users.users.${system.username} = {
    home = "/Users/${system.username}";
    description = system.username;
  };

  nix.settings.trusted-users = [ system.username ];
}
