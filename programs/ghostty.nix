{ system, ...}: {
  home.file.".config/ghostty/config" = {
    text = ''
      theme = Adventure
      font-family = menlo
      title = " "
      macos-titlebar-style = tabs
      window-padding-x = 12
      window-padding-y = 8
      ${if builtins.match ".*darwin" system.system == null then "window-decoration = false" else ""}
    '';
  };
}
