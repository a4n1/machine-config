{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.fingers;
        extraConfig = ''
          bind -n C-n run -b "#{@fingers-cli} start #{pane_id}"
          set -g @fingers-pattern-0 '([\w._\/-][\w._\/ -]+\.[\w.\/:]+)'
          set -g @fingers-pattern-1 '(?<match>[\w._\/-][\w._\/ -]+\.[\w.\/:]+)'
          set -g @fingers-ctrl-action "xargs -I {} tmux run-shell \"cd '#{pane_current_path}' && on '{}'\""
        '';
      }
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
    ];
    extraConfig = ''
      bind r source-file ~/.config/tmux/tmux.conf

      set escape-time 20
      set -g mouse on
      
      set -g base-index 1
      setw -g pane-base-index 1
      set-option -g renumber-windows on

      set-option -g default-terminal xterm-256color

      bind -r h previous-window
      bind -r l next-window 
      bind -r "," swap-window -d -t -1
      bind -r "." swap-window -d -t +1
      bind -r o select-pane -t :.+
      bind -r O select-pane -t :.-
      bind v split-window -v
      bind S split-window -h
      bind s split-window -v "tmux list-sessions -F '#{session_name}' | fzf | xargs -I {} tmux switch-client -t {}"
      bind c new-window '/run/current-system/sw/bin/bash'
 
      set-option -g status-justify absolute-centre
      set-option -g status-position bottom
      set -g status-left ""
      set -g status-left-length 0
      set -g status-right '#[fg=colour15]#S'
 
      set -g window-status-current-format " #[fg=colour15]#W#{?window_zoomed_flag, #[fg=colour2]+,}#{?window_activity_flag, #[fg=colour3]!,}"
      set -g window-status-format " #[fg=colour8]#W#{?window_zoomed_flag, #[fg=colour2]+,}"
      set -g status-style "bg=colour0"
      set -ag status-style "fg=colour9"

      if -F "#{!=:#{status},2}" {
          set -Fg "status-format[1]" "#{status-format[0]}"
          set -g "status-format[0]" ""
          set -g status 2
      }

      # temp fix for fingers colors (fixed in latest tmux version)
      run -b "TERM=tmux-256color #{@fingers-cli} load-config"
    '';
  };
}

