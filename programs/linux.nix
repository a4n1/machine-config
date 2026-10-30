{ pkgs, ... }: {
  imports = [
    ./niri
    ./noctalia.nix
    ./kanshi.nix
  ];

  services.ssh-agent.enable = true;

  home.pointerCursor = {
    enable = true;
    name = "Capitaine Cursors";
    package = pkgs.capitaine-cursors-themed;
    size = 32;
  };

  programs.firefox.configPath = ".mozilla/firefox";
}
