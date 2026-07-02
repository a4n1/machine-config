{ lib, ... }:

{
  imports = [ ];

  # NOTE: Regenerate on the actual VM with `nixos-generate-config` and replace
  # the module list and filesystem UUIDs below with the generated values.
  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "usbhid" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
