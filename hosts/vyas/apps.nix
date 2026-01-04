{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bashInteractive
    blesh
    git
    jujutsu
    neovim
    tmux
    tree
    gawk
    ripgrep
    gnupg
    defaultbrowser
    gnupg
    fzf
    claude-code
    nixd
    luaformatter
    lua-language-server
    htop
    prettier
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
      "google-chrome"
      "cursor"
      "kicad"
      "blender"
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
