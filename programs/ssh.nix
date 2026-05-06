{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    extraConfig = ''
      UseKeychain yes
    '';

    includes = [
      "~/.orbstack/ssh/config"
    ];

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
      };
      "i-*" = {
        user = "ec2-user";
        proxyCommand = ''sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"'';
      };
    };
  };
}
