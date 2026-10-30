{ inputs, ... }: {
  imports = [
    inputs.noctalia.homeModules.default
    ../../../programs
    ../../../programs/desktop.nix
    ../../../programs/linux.nix
  ];

  programs.noctalia.enable = true;
}
