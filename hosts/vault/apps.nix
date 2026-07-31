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
    firefox
    vscodium
    slack
    _1password-gui
    ghostty-bin
    zoom-us
    google-chrome
  ];

  system.defaults.dock = {
    persistent-apps = [
      "/System/Applications/System Settings.app"
      "/Applications/Privileges.app"
      "/Applications/Nix Apps/1Password.app"
      "/Applications/Nix Apps/Bitwarden.app"
      "/Applications/Nix Apps/Slack.app"
      "/Applications/Nix Apps/Firefox.app"
      "/Applications/Nix Apps/Ghostty.app"
      "/Applications/Claude.app"
    ];
  };
}
