{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bashInteractive
    blesh
    git
    jujutsu
    neovim
    zed-editor
    tmux
    tree
    gawk
    ripgrep
    gnupg
    defaultbrowser
    docker
    orbstack
    mkcert
    nssTools
    fzf
    claude-code
    nixd
    luaformatter
    lua-language-server
    wireguard-tools
    htop
    prettier
    tailscale
    bitwarden-desktop
    opencode
    gh
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    casks = [
      "firefox"
      "ghostty"
      "utm"
      "zoom"
      "vscodium"
      "slack"
      "1password"
      "google-chrome"
      "cursor"
      "kicad"
      "android-studio"
      "blender"
      "gimp"
    ];
  };

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/Applications/Privileges.app"
      "/Applications/1Password.app"
      "/Applications/Nix Apps/Bitwarden.app"
      "/Applications/Slack.app"
      "/Applications/Firefox.app"
      "/Applications/Ghostty.app"
      "/Applications/Claude.app"
    ];
  };
}
