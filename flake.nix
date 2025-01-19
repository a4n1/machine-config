{
  description = "a4n1 machine config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05-small";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
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
  }@inputs: let
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
  in {
    darwinConfigurations.vyas = darwin.lib.darwinSystem {
      system = vyas.system;
      specialArgs = { inherit inputs; system = vyas; };
      modules = [
        ./modules/nix-core.nix
        ./modules/darwin/system.nix
        ./modules/darwin/apps.nix
        ./modules/darwin/host-users.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; system = vyas; };
          home-manager.users.${vyas.username} = import ./hosts/vyas/home.nix;
        }
      ];
    };

    nixosConfigurations.vyas-vm = nixpkgs.lib.nixosSystem {
      system = vyas.vm.system;
      specialArgs = { inherit inputs; system = vyas.vm; };
      modules = [
        niri.nixosModules.niri
        stylix.nixosModules.stylix
        ./modules/nix-core.nix
        ./modules/nixos/configuration.nix
        ./hosts/vyas/vm/hardware-configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; system = vyas.vm; };
          home-manager.users.${vyas.vm.username} = import ./hosts/vyas/vm/home.nix;
        }
      ];
    };

    darwinConfigurations.vault = darwin.lib.darwinSystem {
      system = vault.system;
      specialArgs = { inherit inputs; system = vault; };
      modules = [
        ./modules/nix-core.nix
        ./modules/darwin/system.nix
        ./modules/darwin/apps.nix
        ./modules/darwin/host-users.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; system = vault; };
          home-manager.users.${vault.username} = import ./hosts/vault/home.nix;
        }
      ];
    };
  };
}
