{ system, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
   
  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.${system.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.gobble = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" "postgres" ];
    uid = 1002;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;

    settings = {
      listen_addresses = pkgs.lib.mkForce "";
      unix_socket_directories = "/run/postgresql";
    };

    authentication = pkgs.lib.mkOverride 10 ''
      local   all   all   peer
    '';

    ensureDatabases = [ "gobble" ];
    ensureUsers = [
      {
        name = "gobble";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
    };
    oci-containers.containers = {
      gobble = {
        image = "a4n1/gobble:latest";
        ports = ["6001:6001"];
        volumes = [
          "/run/postgresql:/run/postgresql"
        ];
        environment = {
          DATABASE_URL = "postgresql://gobble@/gobble?host=/run/postgresql";
          PORT = "6001";
          NODE_ENV = "production";
        };
        extraOptions = [
          "--user=1002:100"
        ];
      };
    };
  };

   services.cloudflared = {
    enable = true;
    tunnels = {
      "c973e1ea-bf85-4604-816b-163d17587df0" = {
        credentialsFile = "/root/.cloudflared/c973e1ea-bf85-4604-816b-163d17587df0.json";
        default = "http_status:404";
        ingress = {
          "gobble.thirver.com" = "http://localhost:6001";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
