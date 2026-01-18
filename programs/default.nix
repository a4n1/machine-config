{ system, ... }: {
  home = {
    username = system.username;
    homeDirectory = if builtins.match ".*darwin" system.system != null then "/Users/${system.username}" else "/home/${system.username}";
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
