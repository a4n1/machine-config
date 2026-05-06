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
   
  networking.firewall.allowedTCPPorts = [ 22 53 ];

  users.users.${system.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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

    ensureDatabases = [ "gobble" "immich" "spendless" ];
    ensureUsers = [
      {
        name = "gobble";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }

      {
        name = "immich";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }

      {
        name = "spendless";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
        };
      }
    ];
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
    config = {
      DOMAIN = "https://vault.thirver.com";
      SIGNUPS_ALLOWED = false;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 6002;
      ROCKET_LOG = "critical";
    };
  };

  services.dnsmasq = {
    enable = false;
    settings = {
      address = [
        "/.thirver.com/100.119.234.39"
      ];
    };
  };

  services.pihole-ftl = {
    enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      }
    ];
    queryLogDeleter.enable = true;
    settings = {
      misc.readOnly = true;
      dns = {
        upstreams = [ "9.9.9.9" "149.112.112.112" ];
        listeningMode = "ALL";
      };
    };
    useDnsmasqConfig = true;
  };

  services.pihole-web = {
    enable = true;
    ports = [ 6004 ];
  };

  services.immich = {
    enable = true;
    port = 6005;
    host = "photos.thirver.com";
  };

  users.users.gobble = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" "postgres" ];
    uid = 1002;
  };

  users.users.notes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    uid = 1003;
  };

  users.users.spendless = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" "postgres" ];
    uid = 1004;
  };

  virtualisation = {
    podman = {
      enable = true;
    };
    oci-containers.containers = {
      gobble = {
        image = "a4n1/gobble:latest";
        pull = "always";
        ports = ["6001:6001"];
        volumes = ["/run/postgresql:/run/postgresql"];
        environment = {
          DATABASE_URL = "postgresql://gobble@/gobble?host=/run/postgresql";
          PORT = "6001";
          NODE_ENV = "production";
        };
        extraOptions = ["--user=1002:100"];
      };

      notes = {
        image = "a4n1/notes:latest";
        pull = "always";
        ports = ["6003:6003"];
        volumes = ["/home/notes:/data"];
        extraOptions = ["--user=1003:100"];
      };

      spendless = {
        image = "tjgohil/spendless:latest";
        pull = "always";
        ports = ["6006:3001"];
        volumes = ["/run/postgresql:/run/postgresql"];
        environmentFiles = [ "/var/lib/spendless/spendless.env" ];
        extraOptions = ["--user=1004:100"];
      };
    };
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.4" ];
      hash = "sha256-AWeNtf4Eh1WfdLdleYy53n+IGhm4/YGDwXseiCQjblc=";
    };
    globalConfig = ''
      acme_dns cloudflare {
        api_token {$CF_API_TOKEN}
      }
    '';

    virtualHosts."gobble.thirver.com".extraConfig = ''
      reverse_proxy :6001
      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';

    virtualHosts."vault.thirver.com".extraConfig = ''
      encode zstd gzip

      reverse_proxy :6002 {
          header_up X-Real-IP {remote_host}
      }

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';

    virtualHosts."notes.thirver.com".extraConfig = ''
      reverse_proxy :6003

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';

    virtualHosts."notes.a4n1.com".extraConfig = ''
      reverse_proxy :6003

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';

    virtualHosts."dns.thirver.com".extraConfig = ''
      reverse_proxy :6004

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';

    virtualHosts."photos.thirver.com".extraConfig = ''
      reverse_proxy :6005

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';


    virtualHosts."spendless.thirver.com".extraConfig = ''
      reverse_proxy :6006

      tls {
        dns cloudflare {$CF_API_TOKEN}
      }
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = [ "/etc/caddy/cloudflare.env" ];

  system.stateVersion = "25.05";
}
