{ config, pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    keyMode = "vi";
    extraConfig = ''
      bind-key r source-file ~/.config/tmux/tmux.conf

      set escape-time 20
      set -g mouse on
      
      set -g base-index 1
      setw -g pane-base-index 1
      set-option -g renumber-windows on

      set-option -g default-terminal tmux-256color
  
      bind-key h previous-window
      bind-key l next-window 
      bind-key 9 swap-window -t -1
      bind-key 9 swap-window -t -1
      bind-key 0 swap-window -t +1
      bind-key -r "," swap-window -d -t -1
      bind-key -r "." swap-window -d -t +1
 
      set-option -g status-justify absolute-centre
      set-option -g status-position bottom
      set -g status-left '#[fg=color15]#(cd #{pane_current_path} && git rev-parse --abbrev-ref HEAD 4>/dev/null)'
      set -g status-right ""
 
      set -g window-status-current-format " #[fg=colour15]#W#{?window_zoomed_flag, #[fg=colour2]+,}#{?window_activity_flag, #[fg=colour3]!,}"
      set -g window-status-format " #[fg=colour8]#W#{?window_zoomed_flag, #[fg=colour2]+,}"
      set -g status-style "bg=colour0"
      set -ag status-style "fg=colour9"

      if -F "#{!=:#{status},2}" {
          set -Fg "status-format[1]" "#{status-format[0]}"
          set -g "status-format[0]" ""
          set -g status 2
      }
    '';
  };
}

