{
  description = "a4n1 machine config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11-small";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    niri.url = "github:sodiboo/niri-flake";
    stylix.url = "github:danth/stylix";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    niri,
    stylix,
    ...
  }@inputs:
    let overlays = [
      (final: prev: {
        blesh = prev.blesh.overrideAttrs (old: {
          version = "nightly-20251019+2f564e6";
          src = final.fetchzip {
            url = "https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly-20251019+2f564e6.tar.xz";
            sha256 = "sha256-fpNorzJcKs1vVhaYKgRz5vcs6jsEvdxe3N4F2L81Rc0=";
          };
        });
      })
    ];

    vyas = {
      username = "agni";
      system = "x86_64-darwin";
      hostname = "vyas";
      vm = {
        username = "vm";
        system = "x86_64-linux";
        hostname = "vm";
      };
    };

    vault = {
      username = "agni";
      system = "aarch64-darwin";
      hostname = "vault";
    };

    thirver = {
      username = "thir";
      system = "x86_64-linux";
      hostname = "thirver";
    };
  in {
    darwinConfigurations.vyas = darwin.lib.darwinSystem {
      system = vyas.system;
      specialArgs = { inherit inputs; system = vyas; };
      modules = [
        { nixpkgs.overlays = overlays; }
        ./hosts/vyas
        ./modules/nix-core.nix
        ./modules/darwin/system.nix
        ./modules/darwin/host-users.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; system = vyas; };
          home-manager.users.${vyas.username} = import ./hosts/vyas/home.nix;
        }
      ];
    };

    nixosConfigurations.vyas-vm = nixpkgs.lib.nixosSystem {
      system = vyas.vm.system;
      specialArgs = { inherit inputs; system = vyas.vm; };
      modules = [
        { nixpkgs.overlays = overlays; }
        niri.nixosModules.niri
        stylix.nixosModules.stylix
        ./modules/nix-core.nix
        ./modules/nixos/desktop-configuration.nix
        ./hosts/vyas/vm/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; system = vyas.vm; };
          home-manager.users.${vyas.vm.username} = import ./hosts/vyas/vm/home.nix;
        }
      ];
    };

    darwinConfigurations.vault = darwin.lib.darwinSystem {
      system = vault.system;
      specialArgs = { inherit inputs; system = vault; };
      modules = [
        { nixpkgs.overlays = overlays; }
        ./hosts/vault
        ./modules/nix-core.nix
        ./modules/darwin/system.nix
        ./modules/darwin/host-users.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; system = vault; };
          home-manager.users.${vault.username} = import ./hosts/vault/home.nix;
        }
      ];
    };

    nixosConfigurations.thirver = nixpkgs.lib.nixosSystem {
      system = thirver.system;
      specialArgs = { inherit inputs; system = thirver; };
      modules = [
        { nixpkgs.overlays = overlays; }
        ./modules/nix-core.nix
        ./modules/nixos/server-configuration.nix
        ./hosts/thirver/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; system = thirver; };
          home-manager.users.${thirver.username} = import ./hosts/thirver/home.nix;
        }
      ];
    };
  };
}
