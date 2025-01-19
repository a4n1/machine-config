{ system, ...}: {
  home.file.".config/ghostty/config" = {
    text = ''
      theme = Adventure
      font-family = menlo
      title = " "
      macos-titlebar-style = tabs
      window-padding-x = 12
      window-padding-y = 8
      keybind = global:ctrl+grave_accent=toggle_quick_terminal
      keybind = global:cmd+enter=new_window
      ${if builtins.match ".*darwin" system.system == null then "window-decoration = false" else ""}
    '';
  };
}
