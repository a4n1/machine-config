{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bashInteractive
    blesh
    git
    neovim
    tmux
    tree
    gawk
    ripgrep
    gnupg
    defaultbrowser
    lima
    docker
    docker-compose
    mkcert
    nssTools
    fzf
    nixd
    luaformatter
    lua-language-server
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
      "slack"
      "1password"
      "google-chrome"
      "cursor"
      "kicad"
    ];
  };

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/Applications/1Password.app"
      "/Applications/Slack.app"
      "/Applications/Firefox.app"
      "/Applications/Ghostty.app"
    ];
  };
}
