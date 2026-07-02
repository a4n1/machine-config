{ lib, pkgs, ... }:
lib.mkMerge [
  {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

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

  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    programs.ssh = {
      extraConfig = ''
        UseKeychain yes
      '';

      includes = [
        "~/.orbstack/ssh/config"
      ];
    };
  })
]


