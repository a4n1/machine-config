{ pkgs, system, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    theme = pkgs.runCommand "vimix-midnight-black-grub-theme" {
      nativeBuildInputs = [ pkgs.imagemagick ];
      src = pkgs.fetchFromGitHub {
        owner = "trueNAHO";
        repo = "grub2-theme-vimix-very-dark-blue";
        rev = "7b3e61fe047778ae374d61a015343738322591eb";
        hash = "sha256-oRiD85bhvVo8sUu3qkmZg50JRw+Nt6NOsSOVv4utELU=";
      };
    } ''
      mkdir -p "$out"
      cp -r "$src/src/." "$out/"
      chmod -R u+w "$out"
      substituteInPlace "$out/theme.txt" \
        --replace-fail '#1a1b29' '#000000' \
        --replace-fail 'selected_item_color = "#ffffff"' 'selected_item_color = "#89b4fa"' \
        --replace-fail \
          '  selected_item_pixmap_style = "select_*.png"' \
          '  item_pixmap_style = "item_*.png"
    selected_item_pixmap_style = "select_*.png"'

      for selected in "$out"/select_*.png; do
        suffix="''${selected##*/select_}"
        magick "$selected" \
          -channel A -threshold 1% +channel \
          -fill '#1e66f5' -colorize 100% \
          "$selected"
        magick "$selected" -alpha transparent "$out/item_$suffix"
      done
    '';
  };

  networking.networkmanager.enable = true;
  users.users.${system.username}.extraGroups = [ "networkmanager" ];

  services.upower.enable = true;

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  system.stateVersion = "24.05";
}
