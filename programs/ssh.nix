{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      UseKeychain yes
    '';

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
