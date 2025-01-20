{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bashInteractive
    blesh
    git
    neovim
    tmux
    tree
    defaultbrowser
    gnupg
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    taps = [
      "homebrew/services"
    ];

    casks = [
      "firefox"
      "ghostty"
      "utm"
      "zoom"
      "vscodium"
      "vmware-fusion"
    ];
  };

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/Applications/Firefox.app"
      "/Applications/Ghostty.app"
    ];
  };
}
